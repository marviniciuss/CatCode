class_name CommandItem
extends PanelContainer

signal delete_requested(index: int)
signal loop_count_changed(index: int, new_count: int)
signal close_loop_requested()

@onready var hbox: HBoxContainer = $HBox
@onready var index_label: Label = %IndexLabel
@onready var title_label: Label = %TitleLabel
@onready var delete_btn: Button = %DeleteButton
@onready var highlight_border: ColorRect = %HighlightBorder

var item_index: int = 0
var command_type: String = ""
var loop_count: int = 3
var _controls_box: HBoxContainer = null
var _count_btn: Button = null
var _close_loop_btn: Button = null

func setup(index: int, cmd: String, indent_level: int = 0, is_open_loop: bool = false) -> void:
	item_index = index
	command_type = cmd
	
	if index_label:
		index_label.text = "%d." % (index + 1)
	
	var display_title = CommandTypes.get_title(cmd)
	if indent_level > 0 and not CommandTypes.is_loop_start(cmd) and cmd != CommandTypes.LOOP_END:
		display_title = "│ ↳ " + display_title
	
	if title_label:
		title_label.text = display_title
	
	if _controls_box:
		_controls_box.queue_free()
		_controls_box = null
	
	if CommandTypes.is_loop_start(cmd):
		loop_count = CommandTypes.get_loop_count(cmd)
		_build_loop_controls(is_open_loop)
	
	var style = StyleBoxFlat.new()
	var base_color = CommandTypes.get_color(cmd)
	style.bg_color = base_color
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.content_margin_left = 10 + (indent_level * 18)
	style.content_margin_right = 8
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	
	if indent_level > 0:
		style.border_width_left = 5
		style.border_color = Color("#14a3c7")
	
	add_theme_stylebox_override("panel", style)
	
	set_highlight(false)

func _build_loop_controls(is_open_loop: bool) -> void:
	if not hbox:
		return
	
	_controls_box = HBoxContainer.new()
	_controls_box.add_theme_constant_override("separation", 4)
	
	var minus_btn = _create_mini_button("−", Vector2(22, 22))
	minus_btn.tooltip_text = "Diminuir repetições"
	minus_btn.pressed.connect(_on_minus_pressed)
	_controls_box.add_child(minus_btn)
	
	_count_btn = _create_mini_button("%dx" % loop_count, Vector2(34, 22))
	_count_btn.tooltip_text = "Clique para alterar quantas vezes repetir (2x a 6x)"
	_count_btn.pressed.connect(_on_plus_pressed)
	_controls_box.add_child(_count_btn)
	
	var plus_btn = _create_mini_button("+", Vector2(22, 22))
	plus_btn.tooltip_text = "Aumentar repetições"
	plus_btn.pressed.connect(_on_plus_pressed)
	_controls_box.add_child(plus_btn)
	
	if is_open_loop:
		_close_loop_btn = _create_mini_button("✓ Fim", Vector2(46, 22), Color(0.1, 0.45, 0.25, 0.95))
		_close_loop_btn.tooltip_text = "Fechar bloco REPETIR"
		_close_loop_btn.pressed.connect(func(): close_loop_requested.emit())
		_controls_box.add_child(_close_loop_btn)
	
	hbox.add_child(_controls_box)
	hbox.move_child(_controls_box, delete_btn.get_index())

func _create_mini_button(label_text: String, min_size: Vector2, bg: Color = Color(1, 1, 1, 0.25)) -> Button:
	var btn = Button.new()
	btn.text = label_text
	btn.custom_minimum_size = min_size
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.add_theme_font_size_override("font_size", 11)
	btn.add_theme_color_override("font_color", Color.WHITE)
	
	var st = StyleBoxFlat.new()
	st.bg_color = bg
	st.corner_radius_top_left = 8
	st.corner_radius_top_right = 8
	st.corner_radius_bottom_left = 8
	st.corner_radius_bottom_right = 8
	st.content_margin_left = 4
	st.content_margin_right = 4
	st.content_margin_top = 1
	st.content_margin_bottom = 1
	btn.add_theme_stylebox_override("normal", st)
	
	var st_hover = st.duplicate()
	st_hover.bg_color = bg.lightened(0.2)
	btn.add_theme_stylebox_override("hover", st_hover)
	btn.add_theme_stylebox_override("pressed", st)
	return btn

func _on_minus_pressed() -> void:
	var next_count = loop_count - 1
	if next_count < 2:
		next_count = 6
	loop_count_changed.emit(item_index, next_count)

func _on_plus_pressed() -> void:
	var next_count = loop_count + 1
	if next_count > 6:
		next_count = 2
	loop_count_changed.emit(item_index, next_count)

func set_loop_progress(current_iter: int, total_iters: int) -> void:
	if title_label and CommandTypes.is_loop_start(command_type):
		if current_iter > 0:
			title_label.text = "┌ REPETIR (%d/%d)" % [current_iter, total_iters]
		else:
			title_label.text = "┌ REPETIR"

func set_controls_disabled(disabled: bool) -> void:
	if delete_btn:
		delete_btn.disabled = disabled
	if _controls_box:
		for child in _controls_box.get_children():
			if child is Button:
				child.disabled = disabled

func set_highlight(active: bool) -> void:
	if highlight_border:
		highlight_border.visible = active

func _on_delete_pressed() -> void:
	delete_requested.emit(item_index)
