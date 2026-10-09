class_name GameHUD
extends Control

signal command_added(cmd: String)
signal command_removed(index: int)
signal program_cleared
signal run_requested
signal reset_requested
signal back_to_menu_requested
signal next_level_requested
signal retry_level_requested
signal speed_changed(multiplier: float)

@onready var mission_prompt_label: Label = %MissionPromptLabel
@onready var palette_grid: GridContainer = %PaletteGrid
@onready var program_list: VBoxContainer = %ProgramList
@onready var program_scroll: ScrollContainer = %ProgramScroll
@onready var run_button: Button = %RunButton
@onready var reset_button: Button = %ResetButton
@onready var clear_button: Button = %ClearButton
@onready var speed_button: Button = %SpeedButton
@onready var back_button: Button = %BackButton

# Modal de Vitória
@onready var victory_modal: Control = %VictoryModal
@onready var victory_title: Label = %VictoryTitle
@onready var victory_msg: Label = %VictoryMessage
@onready var next_level_btn: Button = %NextLevelButton

# Modal de Falha
@onready var failure_modal: Control = %FailureModal
@onready var failure_reason_label: Label = %FailureReasonLabel

const COMMAND_ITEM_SCENE = preload("res://scenes/ui/command_item.tscn")
const PALETTE_BUTTON_SCENE = preload("res://scenes/ui/palette_button.tscn")

var _command_items: Array[CommandItem] = []
var _is_running: bool = false
var _max_commands: int = 24
var _current_speed_index: int = 1
var _speeds = [0.5, 1.0, 2.0]
var _speed_labels = [".5X", "1X", "2X"]

func setup_level(data: LevelData) -> void:
	mission_prompt_label.text = data.mission_text
	_max_commands = data.max_commands
	
	setup_palette(data.allowed_commands)
	hide_modals()
	set_running_state(false)

func setup_palette(allowed_commands: Array) -> void:
	for child in palette_grid.get_children():
		child.queue_free()
		
	# Botões padrão na ordem da cena_principal.png
	var display_order = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.FEED
	]
	
	for cmd in display_order:
		var btn = PALETTE_BUTTON_SCENE.instantiate() as PaletteButton
		palette_grid.add_child(btn)
		btn.setup(str(cmd))
		
		# Desabilita se o comando não estiver liberado na fase
		if not allowed_commands.has(cmd):
			btn.disabled = true
			btn.modulate.a = 0.5
		
		btn.command_selected.connect(_on_palette_command_selected)

func update_program_display(commands: Array) -> void:
	_command_items.clear()
	for child in program_list.get_children():
		child.queue_free()
		
	for i in range(commands.size()):
		var item = COMMAND_ITEM_SCENE.instantiate() as CommandItem
		program_list.add_child(item)
		item.setup(i, str(commands[i]))
		item.delete_requested.connect(_on_item_delete_requested)
		_command_items.append(item)
		
	# Rolar automaticamente para o final
	await get_tree().process_frame
	if program_scroll:
		program_scroll.scroll_vertical = int(program_scroll.get_v_scroll_bar().max_value)

func highlight_command(index: int) -> void:
	for i in range(_command_items.size()):
		if is_instance_valid(_command_items[i]):
			_command_items[i].set_highlight(i == index)

func clear_highlights() -> void:
	for item in _command_items:
		if is_instance_valid(item):
			item.set_highlight(false)

func set_running_state(running: bool) -> void:
	_is_running = running
	run_button.disabled = running
	clear_button.disabled = running
	
	for child in palette_grid.get_children():
		if child is Button:
			child.disabled = running
			
	for item in _command_items:
		if is_instance_valid(item):
			var del_btn = item.get_node_or_null("%DeleteButton")
			if del_btn:
				del_btn.disabled = running

func show_victory(step_count: int, is_last_level: bool = false) -> void:
	victory_modal.visible = true
	victory_title.text = "🎉 Missão Concluída!"
	victory_msg.text = "O gatinho foi alimentado com sucesso em %d passos!\nParabéns, você pensou como um verdadeiro programador!" % step_count
	next_level_btn.visible = not is_last_level
	if is_last_level:
		next_level_btn.text = "Concluir"

func show_failure(reason: String) -> void:
	failure_modal.visible = true
	match reason:
		"bump_edge":
			failure_reason_label.text = "O robô atingiu a borda do gramado!\nRevise a sequência para mantê-lo dentro do caminho seguro."
		"bump_obstacle":
			failure_reason_label.text = "O robô esbarrou no arbusto!\nUse 'Vire à Esquerda' ou 'Vire à Direita' para desviar dos obstáculos."
		"nothing_to_collect":
			failure_reason_label.text = "O comando 'Coletar' foi executado, mas não há ração nessa casa!\nConduza o robô até a tigela primeiro."
		"not_at_animal":
			failure_reason_label.text = "O robô tentou alimentar, mas o animal não está nessa casa!\nLeve o robô até a gatinha Mia."
		"no_food_in_hands":
			failure_reason_label.text = "O robô chegou até a Mia, mas não está carregando a comida!\nLembre-se de usar 'Coletar' na ração antes de ir até ela."
		"food_not_collected":
			failure_reason_label.text = "A sequência terminou, mas a comida não foi recolhida!\nNão esqueça do bloco 'Coletar'."
		"empty_program":
			failure_reason_label.text = "Adicione comandos à lista antes de executar!"
		_:
			failure_reason_label.text = "A missão ainda não foi concluída. Ajuste os blocos e tente de novo!"

func hide_modals() -> void:
	victory_modal.visible = false
	failure_modal.visible = false

func _on_palette_command_selected(cmd: String) -> void:
	if not _is_running:
		command_added.emit(cmd)

func _on_item_delete_requested(index: int) -> void:
	if not _is_running:
		command_removed.emit(index)

func _on_run_pressed() -> void:
	run_requested.emit()

func _on_reset_pressed() -> void:
	reset_requested.emit()

func _on_clear_pressed() -> void:
	program_cleared.emit()

func _on_speed_pressed() -> void:
	_current_speed_index = (_current_speed_index + 1) % _speeds.size()
	speed_button.text = _speed_labels[_current_speed_index]
	speed_changed.emit(_speeds[_current_speed_index])

func _on_back_pressed() -> void:
	back_to_menu_requested.emit()

func _on_next_level_pressed() -> void:
	hide_modals()
	next_level_requested.emit()

func _on_retry_pressed() -> void:
	hide_modals()
	retry_level_requested.emit()
