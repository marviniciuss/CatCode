class_name CommandItem
extends PanelContainer

signal delete_requested(index: int)
signal loop_count_changed(index: int, new_count: int)
signal if_condition_toggled(index: int, next_cond: String)
signal close_loop_requested()

@onready var hbox: HBoxContainer = $HBox
@onready var index_label: Label = %IndexLabel
@onready var title_label: Label = %TitleLabel
@onready var delete_btn: Button = %DeleteButton
@onready var highlight_border: ColorRect = %HighlightBorder

var item_index: int = 0
var command_type: String = ""
var loop_count: int = 3
var _indent_level: int = 0
var _is_if_child: bool = false
var _left_offset: float = 0.0
var _card_style: StyleBoxFlat = null
var _is_highlighted: bool = false
var _controls_box: HBoxContainer = null
var _count_btn: Button = null
var _close_loop_btn: Button = null

func setup(index: int, cmd: String, indent_level: int = 0, is_open_loop: bool = false, is_if_child: bool = false) -> void:
	item_index = index
	command_type = cmd
	_indent_level = indent_level
	_is_if_child = is_if_child
	
	if _is_if_child:
		_left_offset = 46.0 if indent_level >= 2 else 30.0
	elif indent_level == 1:
		_left_offset = 16.0
	else:
		_left_offset = 0.0
	
	if index_label:
		index_label.text = "%d." % (index + 1)
	
	var display_title = CommandTypes.get_title(cmd)
	if _is_if_child:
		display_title = "↳ " + display_title
	elif indent_level == 1 and not CommandTypes.is_loop_start(cmd) and cmd != CommandTypes.LOOP_END:
		display_title = "↳ " + display_title
	
	if title_label:
		title_label.text = display_title
	
	if _controls_box:
		_controls_box.queue_free()
		_controls_box = null
	
	if CommandTypes.is_loop_start(cmd):
		loop_count = CommandTypes.get_loop_count(cmd)
		_build_loop_controls(is_open_loop)
	elif CommandTypes.is_if_cmd(cmd):
		_build_if_controls(CommandTypes.get_if_condition(cmd))
	
	_card_style = StyleBoxFlat.new()
	var base_color = CommandTypes.get_color(cmd)
	_card_style.bg_color = base_color
	_card_style.corner_radius_top_left = 12
	_card_style.corner_radius_top_right = 12
	_card_style.corner_radius_bottom_left = 12
	_card_style.corner_radius_bottom_right = 12
	
	if _is_if_child:
		_card_style.border_width_left = 4
		_card_style.border_color = Color("#e67e22")
	elif indent_level == 1:
		_card_style.border_width_left = 4
		_card_style.border_color = Color("#14a3c7")
	
	var empty_style = StyleBoxEmpty.new()
	empty_style.content_margin_left = 10.0 + _left_offset
	empty_style.content_margin_right = 8.0
	empty_style.content_margin_top = 4.0
	empty_style.content_margin_bottom = 4.0
	add_theme_stylebox_override("panel", empty_style)
	
	if highlight_border:
		highlight_border.visible = false
	
	set_highlight(false)
	queue_redraw()

func _draw() -> void:
	# Barra vertical azul do REPETIR
	if _indent_level >= 1:
		draw_line(Vector2(6.0, 0.0), Vector2(6.0, size.y), Color("#14a3c7"), 3.0)
	
	# Conector laranja em "L" ligando o bloco ao SE acima dele
	if _is_if_child:
		var branch_x = _left_offset - 14.0
		draw_line(Vector2(branch_x, 0.0), Vector2(branch_x, size.y * 0.52), Color("#e67e22"), 3.0)
		draw_line(Vector2(branch_x, size.y * 0.52), Vector2(_left_offset, size.y * 0.52), Color("#e67e22"), 3.0)
	
	# Desenha o cartão colorido recuado para a direita (com largura menor quando aninhado)
	if _card_style:
		var card_rect = Rect2(_left_offset, 0.0, maxf(40.0, size.x - _left_offset), size.y)
		draw_style_box(_card_style, card_rect)
		
		if _is_highlighted:
			var hl_style = StyleBoxFlat.new()
			hl_style.bg_color = Color(1.0, 1.0, 0.4, 0.38)
			hl_style.border_width_left = 2
			hl_style.border_width_top = 2
			hl_style.border_width_right = 2
			hl_style.border_width_bottom = 2
			hl_style.border_color = Color(1.0, 0.95, 0.2, 0.95)
			hl_style.corner_radius_top_left = 12
			hl_style.corner_radius_top_right = 12
			hl_style.corner_radius_bottom_left = 12
			hl_style.border_width_bottom = 2
			hl_style.corner_radius_bottom_right = 12
			draw_style_box(hl_style, card_rect)

func _build_if_controls(current_cond: String) -> void:
	if not hbox:
		return
	
	_controls_box = HBoxContainer.new()
	_controls_box.add_theme_constant_override("separation", 4)
	
	var cond_btn = _create_mini_button(CommandTypes.get_condition_label(current_cond), Vector2(96, 22), Color(0, 0, 0, 0.25))
	cond_btn.tooltip_text = "Clique para alternar entre 'Obstáculo à Frente' e 'Sobre Ração'"
	cond_btn.pressed.connect(func():
		var next_c = CommandTypes.COND_ON_FOOD if current_cond == CommandTypes.COND_OBSTACLE_AHEAD else CommandTypes.COND_OBSTACLE_AHEAD
		if_condition_toggled.emit(item_index, next_c)
	)
	_controls_box.add_child(cond_btn)
	
	hbox.add_child(_controls_box)
	hbox.move_child(_controls_box, delete_btn.get_index())

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
	_is_highlighted = active
	if highlight_border:
		highlight_border.visible = false
	queue_redraw()

func _on_delete_pressed() -> void:
	delete_requested.emit(item_index)
