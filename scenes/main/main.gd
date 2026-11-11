class_name MainGame
extends Node

@onready var hud: GameHUD = $HUD
@onready var board_viewport: SubViewport = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport
@onready var camera: Camera2D = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Camera2D
@onready var board: GridBoard = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Board
@onready var robot: Robot = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Robot

var levels: Array[LevelData] = []
var current_level_index: int = 0
var program_commands: Array[String] = []
var is_executing: bool = false
var cancel_execution: bool = false
var execution_speed: float = 1.0

func _ready() -> void:
	_connect_hud_signals()
	levels = LevelData.get_default_levels()
	var start_index = clampi(LevelData.selected_level_index, 0, levels.size() - 1)
	load_level(start_index)

func _connect_hud_signals() -> void:
	hud.command_added.connect(_on_command_added)
	hud.command_removed.connect(_on_command_removed)
	hud.loop_count_changed.connect(_on_loop_count_changed)
	hud.program_cleared.connect(_on_program_cleared)
	hud.run_requested.connect(_on_run_requested)
	hud.reset_requested.connect(_on_reset_requested)
	hud.speed_changed.connect(_on_speed_changed)
	hud.back_to_menu_requested.connect(_on_back_to_menu_requested)
	hud.next_level_requested.connect(_on_next_level_requested)
	hud.retry_level_requested.connect(_on_retry_level_requested)

func load_level(index: int) -> void:
	if index < 0 or index >= levels.size():
		return
		
	current_level_index = index
	LevelData.selected_level_index = index
	var current_level = levels[current_level_index]
	
	program_commands.clear()
	is_executing = false
	cancel_execution = false
	
	# Configurar Tabuleiro e Robô
	board.setup_level(current_level)
	robot.setup(current_level.robot_start_pos, current_level.robot_start_dir, board)
	
	# Configurar HUD
	hud.setup_level(current_level)
	hud.update_program_display(program_commands)

func _has_open_loop() -> bool:
	var open_loop = false
	for c in program_commands:
		if CommandTypes.is_loop_start(c):
			open_loop = true
		elif c == CommandTypes.LOOP_END:
			open_loop = false
	return open_loop

func _on_command_added(cmd: String) -> void:
	var current_level = levels[current_level_index]
	if program_commands.size() >= current_level.max_commands:
		return
	
	if cmd == CommandTypes.LOOP:
		if _has_open_loop():
			program_commands.append(CommandTypes.LOOP_END)
		else:
			program_commands.append(CommandTypes.make_loop_cmd(3))
	else:
		program_commands.append(cmd)
		
	hud.update_program_display(program_commands)

func _on_loop_count_changed(index: int, new_count: int) -> void:
	if index >= 0 and index < program_commands.size():
		if CommandTypes.is_loop_start(program_commands[index]):
			program_commands[index] = CommandTypes.make_loop_cmd(new_count)
			hud.update_program_display(program_commands)

func _on_command_removed(index: int) -> void:
	if index >= 0 and index < program_commands.size():
		var removed_cmd = program_commands[index]
		program_commands.remove_at(index)
		
		# Se removeu o cabeçalho do REPETIR, remove também o seu FIM REPETIR correspondente
		if CommandTypes.is_loop_start(removed_cmd):
			for j in range(index, program_commands.size()):
				if CommandTypes.is_loop_start(program_commands[j]):
					break
				if program_commands[j] == CommandTypes.LOOP_END:
					program_commands.remove_at(j)
					break
					
		hud.update_program_display(program_commands)

func _on_program_cleared() -> void:
	program_commands.clear()
	hud.update_program_display(program_commands)

func _on_speed_changed(multiplier: float) -> void:
	execution_speed = multiplier
	Engine.time_scale = multiplier

func _on_run_requested() -> void:
	if is_executing:
		return
		
	if program_commands.is_empty():
		hud.show_failure("empty_program")
		return
		
	_reset_board_and_robot()
	_execute_program()

func _reset_board_and_robot() -> void:
	var current_level = levels[current_level_index]
	board.reset_board_state()
	robot.setup(current_level.robot_start_pos, current_level.robot_start_dir, board)
	hud.clear_highlights()

func _on_reset_requested() -> void:
	cancel_execution = true
	is_executing = false
	hud.set_running_state(false)
	_reset_board_and_robot()

func _execute_single_action(cmd: String) -> Dictionary:
	var action_result: Dictionary = { "success": true }
	match cmd:
		CommandTypes.MOVE_FORWARD:
			robot.move_forward()
			action_result = await robot.action_finished
		CommandTypes.TURN_LEFT:
			robot.turn_left()
			action_result = await robot.action_finished
		CommandTypes.TURN_RIGHT:
			robot.turn_right()
			action_result = await robot.action_finished
		CommandTypes.COLLECT:
			robot.collect()
			action_result = await robot.action_finished
		CommandTypes.FEED:
			robot.feed()
			action_result = await robot.action_finished
	return action_result

func _execute_program() -> void:
	is_executing = true
	cancel_execution = false
	hud.set_running_state(true)
	
	await get_tree().create_timer(0.25).timeout
	
	var i: int = 0
	while i < program_commands.size():
		if cancel_execution:
			break
			
		var cmd = program_commands[i]
		
		if CommandTypes.is_loop_start(cmd):
			var repeat_count = CommandTypes.get_loop_count(cmd)
			var end_idx = program_commands.size()
			for j in range(i + 1, program_commands.size()):
				if program_commands[j] == CommandTypes.LOOP_END:
					end_idx = j
					break
				elif CommandTypes.is_loop_start(program_commands[j]):
					end_idx = j
					break
			
			if end_idx <= i + 1:
				hud.highlight_command(i)
				await get_tree().create_timer(0.15).timeout
			else:
				for rep in range(1, repeat_count + 1):
					if cancel_execution or board.is_animal_fed:
						break
					for inner_idx in range(i + 1, end_idx):
						if cancel_execution:
							break
						var inner_cmd = program_commands[inner_idx]
						hud.highlight_command(inner_idx, i, rep, repeat_count)
						var loop_res = await _execute_single_action(inner_cmd)
						
						if not loop_res.get("success", true):
							hud.clear_highlights()
							hud.set_running_state(false)
							is_executing = false
							hud.show_failure(loop_res.get("reason", "error"))
							return
						
						if board.is_animal_fed:
							break
						
						await get_tree().create_timer(0.15).timeout
			
			if board.is_animal_fed:
				break
			i = end_idx + 1 if end_idx < program_commands.size() and program_commands[end_idx] == CommandTypes.LOOP_END else end_idx
			continue
		elif cmd == CommandTypes.LOOP_END:
			i += 1
			continue
		
		hud.highlight_command(i)
		var action_result = await _execute_single_action(cmd)
		
		# Checar se ocorreu erro no passo
		if not action_result.get("success", true):
			hud.clear_highlights()
			hud.set_running_state(false)
			is_executing = false
			hud.show_failure(action_result.get("reason", "error"))
			return
		
		# Se já alimentou o animal, encerra com vitória
		if board.is_animal_fed:
			break
			
		await get_tree().create_timer(0.15).timeout
		i += 1
	
	hud.clear_highlights()
	hud.set_running_state(false)
	is_executing = false
	
	if cancel_execution:
		return
		
	# Avaliar condição final da missão
	if board.is_animal_fed:
		LevelData.unlock_next_level(current_level_index)
		var is_last = (current_level_index >= levels.size() - 1)
		hud.show_victory(program_commands.size(), is_last)
	elif not robot.is_carrying_item and board.has_food:
		hud.show_failure("food_not_collected")
	elif robot.is_carrying_item:
		hud.show_failure("not_at_animal")
	else:
		hud.show_failure("generic")

func _on_back_to_menu_requested() -> void:
	Engine.time_scale = 1.0
	if ResourceLoader.exists("res://scenes/menus/level_select.tscn"):
		get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
	elif ResourceLoader.exists("res://scenes/menus/start_menu.tscn"):
		get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")

func _on_next_level_requested() -> void:
	if current_level_index + 1 < levels.size():
		load_level(current_level_index + 1)
	else:
		load_level(0)

func _on_retry_level_requested() -> void:
	_reset_board_and_robot()
	hud.set_running_state(false)
