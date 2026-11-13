class_name MainGame
extends Node

@onready var hud: GameHUD = $HUD
@onready var board_viewport: SubViewport = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport
@onready var camera: Camera2D = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Camera2D
@onready var board: GridBoard = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Board
@onready var robot: Robot = $HUD/WorldSide/BoardFrame/BoardViewportContainer/BoardSubViewport/Robot

const MAX_UNTIL_ITERATIONS := 50

var levels: Array[LevelData] = []
var current_level_index: int = 0
var program_commands: Array[String] = []
var is_executing: bool = false
var cancel_execution: bool = false
var execution_speed: float = 1.0

var _functions: Dictionary = {}
var _stop: bool = false
var _fail_reason: String = ""
var _call_depth: int = 0

func _ready() -> void:
	AudioManager.play_match_music()
	_connect_hud_signals()
	levels = LevelData.get_default_levels()
	var start_index = clampi(LevelData.selected_level_index, 0, levels.size() - 1)
	load_level(start_index)

func _connect_hud_signals() -> void:
	hud.command_added.connect(_on_command_added)
	hud.command_removed.connect(_on_command_removed)
	hud.loop_count_changed.connect(_on_loop_count_changed)
	hud.if_condition_toggled.connect(_on_if_condition_toggled)
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
	
	board.setup_level(current_level)
	robot.setup(current_level.robot_start_pos, current_level.robot_start_dir, board)
	
	hud.setup_level(current_level)
	hud.update_program_display(program_commands)

# ---------------------------------------------------------------
# Edição do programa
# ---------------------------------------------------------------
func _is_simple(c: String) -> bool:
	return c in [CommandTypes.MOVE_FORWARD, CommandTypes.TURN_LEFT, CommandTypes.TURN_RIGHT,
			CommandTypes.COLLECT, CommandTypes.FEED]

func _is_block_start(c: String) -> bool:
	return CommandTypes.is_loop_start(c) or CommandTypes.is_until_start(c) or c == CommandTypes.FUNC_DEF

# Pilha de blocos abertos (o último é o mais interno)
func _block_stack() -> Array:
	var stack: Array = []
	for c in program_commands:
		if CommandTypes.is_loop_start(c):
			stack.append("LOOP")
		elif CommandTypes.is_until_start(c):
			stack.append("UNTIL")
		elif c == CommandTypes.FUNC_DEF:
			stack.append("FUNC")
		elif (c == CommandTypes.LOOP_END or c == CommandTypes.FUNC_END) and not stack.is_empty():
			stack.pop_back()
	return stack

func _has_function_def() -> bool:
	return program_commands.has(CommandTypes.FUNC_DEF)

func _can_add_else() -> bool:
	var n = program_commands.size()
	return n >= 2 and CommandTypes.is_if_cmd(program_commands[n - 2]) and _is_simple(program_commands[n - 1])

func _on_command_added(cmd: String) -> void:
	var current_level = levels[current_level_index]
	if program_commands.size() >= current_level.max_commands:
		return

	var stack = _block_stack()
	var top: String = stack.back() if not stack.is_empty() else ""

	match cmd:
		CommandTypes.LOOP:
			if top == "LOOP":
				program_commands.append(CommandTypes.LOOP_END)
			else:
				program_commands.append(CommandTypes.make_loop_cmd(3))
		CommandTypes.UNTIL:
			if top == "UNTIL":
				program_commands.append(CommandTypes.LOOP_END)
			else:
				program_commands.append(CommandTypes.make_until_cmd(CommandTypes.COND_ON_ANIMAL))
		CommandTypes.FUNC_DEF:
			if top == "FUNC":
				program_commands.append(CommandTypes.FUNC_END)
			elif _has_function_def():
				return
			else:
				program_commands.append(CommandTypes.FUNC_DEF)
		CommandTypes.ELSE:
			if not _can_add_else():
				return
			program_commands.append(CommandTypes.ELSE)
		_:
			program_commands.append(cmd)

	hud.update_program_display(program_commands)

func _on_loop_count_changed(index: int, new_count: int) -> void:
	if index >= 0 and index < program_commands.size():
		if CommandTypes.is_loop_start(program_commands[index]):
			program_commands[index] = CommandTypes.make_loop_cmd(new_count)
			hud.update_program_display(program_commands)

func _on_if_condition_toggled(index: int, next_cond: String) -> void:
	if index >= 0 and index < program_commands.size():
		program_commands[index] = CommandTypes.with_condition(program_commands[index], next_cond)
		hud.update_program_display(program_commands)

func _find_block_end(start: int) -> int:
	var depth = 0
	for j in range(start, program_commands.size()):
		var c = program_commands[j]
		if _is_block_start(c):
			depth += 1
		elif c == CommandTypes.LOOP_END or c == CommandTypes.FUNC_END:
			depth -= 1
			if depth == 0:
				return j
	return -1

func _on_command_removed(index: int) -> void:
	if index < 0 or index >= program_commands.size():
		return
	var cmd = program_commands[index]

	if _is_block_start(cmd):
		var end_idx = _find_block_end(index)
		if end_idx != -1:
			program_commands.remove_at(end_idx)
	elif cmd == CommandTypes.ELSE:
		if index + 1 < program_commands.size() and _is_simple(program_commands[index + 1]):
			program_commands.remove_at(index + 1)

	program_commands.remove_at(index)
	hud.update_program_display(program_commands)

func _on_program_cleared() -> void:
	program_commands.clear()
	hud.update_program_display(program_commands)

func _on_speed_changed(multiplier: float) -> void:
	execution_speed = multiplier
	Engine.time_scale = multiplier

# ---------------------------------------------------------------
# Execução
# ---------------------------------------------------------------
func _on_run_requested() -> void:
	if is_executing:
		return
	if program_commands.is_empty():
		hud.show_failure("empty_program")
		return
	_reset_board_and_robot()
	_execute_program()

func _reset_board_and_robot() -> void:
	AudioManager.play_match_music()
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

func _check_condition(cond: String) -> bool:
	match cond:
		CommandTypes.COND_ON_FOOD:
			return board.has_food and robot.grid_pos == board.food_pos
		CommandTypes.COND_ON_ANIMAL:
			return robot.grid_pos == board.animal_pos
		_:
			return robot.is_blocked_ahead()

func _parse_block(start: int, out: Array) -> int:
	var i = start
	var n = program_commands.size()
	while i < n:
		var c: String = program_commands[i]
		if c == CommandTypes.LOOP_END or c == CommandTypes.FUNC_END:
			return i
		if _is_block_start(c):
			var body: Array = []
			var end_i = _parse_block(i + 1, body)
			var node = {"idx": i, "body": body}
			if CommandTypes.is_loop_start(c):
				node["type"] = "loop"
				node["count"] = CommandTypes.get_loop_count(c)
			elif CommandTypes.is_until_start(c):
				node["type"] = "until"
				node["cond"] = CommandTypes.get_until_condition(c)
			else:
				node["type"] = "def"
			out.append(node)
			i = end_i + 1
		elif CommandTypes.is_if_cmd(c):
			var node = {"type": "if", "idx": i, "cond": CommandTypes.get_if_condition(c), "then": {}, "else": {}}
			i += 1
			if i < n and _is_simple(program_commands[i]):
				node["then"] = {"type": "cmd", "idx": i, "cmd": program_commands[i]}
				i += 1
			if i < n and program_commands[i] == CommandTypes.ELSE:
				i += 1
				if i < n and _is_simple(program_commands[i]):
					node["else"] = {"type": "cmd", "idx": i, "cmd": program_commands[i]}
					i += 1
			out.append(node)
		elif c == CommandTypes.ELSE:
			i += 1
		elif c == CommandTypes.FUNC_CALL:
			out.append({"type": "call", "idx": i})
			i += 1
		else:
			out.append({"type": "cmd", "idx": i, "cmd": c})
			i += 1
	return i

func _collect_functions(nodes: Array) -> void:
	for node in nodes:
		if node["type"] == "def":
			if not _functions.has("main"):
				_functions["main"] = node["body"]
		elif node.has("body"):
			_collect_functions(node["body"])

func _highlight(idx: int, ctx: Dictionary) -> void:
	if ctx.has("loop_idx"):
		hud.highlight_command(idx, ctx["loop_idx"], ctx["rep"], ctx["total"])
	else:
		hud.highlight_command(idx)

func _run_nodes(nodes: Array, ctx: Dictionary = {}) -> void:
	for node in nodes:
		if _stop:
			return
		await _run_node(node, ctx)

func _run_node(node: Dictionary, ctx: Dictionary) -> void:
	if cancel_execution:
		_stop = true
		return

	match node["type"]:
		"cmd":
			_highlight(node["idx"], ctx)
			var res = await _execute_single_action(node["cmd"])
			if cancel_execution:
				_stop = true
				return
			if not res.get("success", true):
				_fail_reason = res.get("reason", "error")
				_stop = true
				return
			if board.is_animal_fed:
				_stop = true
				return
			await get_tree().create_timer(0.15).timeout

		"if":
			_highlight(node["idx"], ctx)
			await get_tree().create_timer(0.15).timeout
			var branch: Dictionary = node["then"] if _check_condition(node["cond"]) else node["else"]
			if not branch.is_empty():
				await _run_node(branch, ctx)

		"loop":
			if node["body"].is_empty():
				_highlight(node["idx"], ctx)
				await get_tree().create_timer(0.15).timeout
				return
			for rep in range(1, node["count"] + 1):
				var inner = {"loop_idx": node["idx"], "rep": rep, "total": node["count"]}
				await _run_nodes(node["body"], inner)
				if _stop:
					return

		"until":
			if node["body"].is_empty():
				_fail_reason = "infinite_loop"
				_stop = true
				return
			var guard = 0
			while not _check_condition(node["cond"]):
				if guard >= MAX_UNTIL_ITERATIONS:
					_fail_reason = "infinite_loop"
					_stop = true
					return
				guard += 1
				await _run_nodes(node["body"], {"loop_idx": node["idx"], "rep": guard, "total": MAX_UNTIL_ITERATIONS})
				if _stop:
					return

		"call":
			_highlight(node["idx"], ctx)
			if _call_depth > 0:
				_fail_reason = "function_recursion"
				_stop = true
				return
			if not _functions.has("main"):
				_fail_reason = "function_undefined"
				_stop = true
				return
			await get_tree().create_timer(0.15).timeout
			_call_depth += 1
			await _run_nodes(_functions["main"], {})
			_call_depth -= 1

		"def":
			pass # a definição só roda via CHAMAR

func _execute_program() -> void:
	is_executing = true
	cancel_execution = false
	_stop = false
	_fail_reason = ""
	_call_depth = 0
	_functions.clear()
	hud.set_running_state(true)

	await get_tree().create_timer(0.25).timeout

	var tree: Array = []
	var i = 0
	while i < program_commands.size():
		i = _parse_block(i, tree) + 1
	_collect_functions(tree)

	await _run_nodes(tree)

	hud.clear_highlights()
	hud.set_running_state(false)
	is_executing = false

	if cancel_execution:
		return
	if _fail_reason != "":
		hud.show_failure(_fail_reason)
		return

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
