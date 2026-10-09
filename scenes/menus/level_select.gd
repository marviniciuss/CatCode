class_name LevelSelectMenu
extends Control

@onready var back_button: Button = %BackButton
@onready var levels_grid: GridContainer = %LevelsGrid

func _ready() -> void:
	_setup_level_buttons()

func _setup_level_buttons() -> void:
	for child in levels_grid.get_children():
		if child is Button:
			var lvl_num = child.text.to_int()
			child.pressed.connect(_on_level_selected.bind(lvl_num))

func _on_level_selected(level_num: int) -> void:
	# Por enquanto iniciamos na cena principal
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")
