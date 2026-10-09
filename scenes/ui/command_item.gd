class_name CommandItem
extends PanelContainer

signal delete_requested(index: int)

@onready var index_label: Label = %IndexLabel
@onready var title_label: Label = %TitleLabel
@onready var delete_btn: Button = %DeleteButton
@onready var highlight_border: ColorRect = %HighlightBorder

var item_index: int = 0
var command_type: String = ""

func setup(index: int, cmd: String) -> void:
	item_index = index
	command_type = cmd
	
	if index_label:
		index_label.text = "%d." % (index + 1)
	if title_label:
		title_label.text = CommandTypes.get_title(cmd)
	
	var style = StyleBoxFlat.new()
	var base_color = CommandTypes.get_color(cmd)
	style.bg_color = base_color
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.content_margin_left = 10
	style.content_margin_right = 8
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	add_theme_stylebox_override("panel", style)
	
	set_highlight(false)

func set_highlight(active: bool) -> void:
	if highlight_border:
		highlight_border.visible = active

func _on_delete_pressed() -> void:
	delete_requested.emit(item_index)
