class_name LevelSelectMenu
extends Control

@onready var back_button: Button = %BackButton
@onready var levels_grid: GridContainer = %LevelsGrid

func _ready() -> void:
	UISounds.register_buttons(self)
	AudioManager.play_theme_music()
	_setup_level_buttons()

func _setup_level_buttons() -> void:
	var total_levels = LevelData.get_default_levels().size()
	var unlocked_style = _create_button_style(true)
	var hover_style = _create_button_hover_style()
	var locked_style = _create_button_style(false)

	var buttons = levels_grid.get_children()
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		if not btn:
			continue

		var lvl_num = i + 1
		var is_unlocked = (lvl_num <= total_levels) and (lvl_num <= LevelData.max_unlocked_level)

		if is_unlocked:
			btn.disabled = false
			btn.text = str(lvl_num)
			btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			btn.add_theme_font_size_override("font_size", 28)
			btn.add_theme_color_override("font_color", Color(0.23, 0.03, 0.39, 1.0))
			btn.add_theme_color_override("font_hover_color", Color(0.35, 0.05, 0.55, 1.0))
			btn.add_theme_color_override("font_pressed_color", Color(0.23, 0.03, 0.39, 1.0))
			btn.add_theme_stylebox_override("normal", unlocked_style)
			btn.add_theme_stylebox_override("hover", hover_style)
			btn.add_theme_stylebox_override("pressed", unlocked_style)
			btn.pressed.connect(_on_level_selected.bind(lvl_num))
		else:
			btn.disabled = true
			btn.text = "%d\n🔒" % lvl_num
			btn.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
			btn.add_theme_font_size_override("font_size", 22)
			btn.add_theme_color_override("font_color", Color(0.3, 0.15, 0.4, 0.7))
			btn.add_theme_color_override("font_disabled_color", Color(0.3, 0.15, 0.4, 0.7))
			btn.add_theme_stylebox_override("normal", locked_style)
			btn.add_theme_stylebox_override("disabled", locked_style)

func _create_button_style(unlocked: bool) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_right = 22
	style.corner_radius_bottom_left = 22
	if unlocked:
		style.bg_color = Color(0.85, 0.73, 0.93, 1.0)
		style.border_width_left = 3
		style.border_width_top = 3
		style.border_width_right = 3
		style.border_width_bottom = 3
		style.border_color = Color(0.23, 0.03, 0.39, 1.0)
		style.shadow_color = Color(0, 0, 0, 0.08)
		style.shadow_size = 4
		style.shadow_offset = Vector2(0, 3)
	else:
		style.bg_color = Color(0.85, 0.73, 0.93, 0.55)
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
		style.border_color = Color(0.4, 0.2, 0.5, 0.4)
	return style

func _create_button_hover_style() -> StyleBoxFlat:
	var style = _create_button_style(true)
	style.bg_color = Color(0.92, 0.82, 0.98, 1.0)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 4)
	return style

func _on_level_selected(level_num: int) -> void:
	var total_levels = LevelData.get_default_levels().size()
	if level_num < 1 or level_num > total_levels or level_num > LevelData.max_unlocked_level:
		return
	LevelData.selected_level_index = level_num - 1
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")
