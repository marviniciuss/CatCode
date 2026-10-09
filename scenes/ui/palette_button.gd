class_name PaletteButton
extends Button

signal command_selected(cmd: String)

var command_type: String = ""

func setup(cmd: String) -> void:
	command_type = cmd
	text = CommandTypes.get_title(cmd)
	tooltip_text = CommandTypes.get_description(cmd)
	
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_minimum_size = Vector2(130, 36)
	
	add_theme_font_size_override("font_size", 12)
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", Color(0.9, 0.9, 0.9))
	
	var base_color: Color = CommandTypes.get_color(cmd)
	
	# Estilo normal (pílula arredondada)
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = base_color
	normal_style.corner_radius_top_left = 18
	normal_style.corner_radius_top_right = 18
	normal_style.corner_radius_bottom_left = 18
	normal_style.corner_radius_bottom_right = 18
	normal_style.content_margin_left = 10
	normal_style.content_margin_right = 10
	normal_style.content_margin_top = 6
	normal_style.content_margin_bottom = 6
	add_theme_stylebox_override("normal", normal_style)
	
	# Estilo hover
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = base_color.lightened(0.12)
	add_theme_stylebox_override("hover", hover_style)
	
	# Estilo pressed
	var pressed_style = normal_style.duplicate()
	pressed_style.bg_color = base_color.darkened(0.15)
	add_theme_stylebox_override("pressed", pressed_style)
	
	# Estilo disabled
	var disabled_style = normal_style.duplicate()
	disabled_style.bg_color = base_color.darkened(0.4)
	add_theme_stylebox_override("disabled", disabled_style)

func _pressed() -> void:
	command_selected.emit(command_type)
