class_name StartMenu
extends Control

@onready var start_button: Button = %StartButton
@onready var how_to_play_button: Button = %HowToPlayButton
@onready var how_to_play_modal: Control = %HowToPlayModal
@onready var close_help_button: Button = %CloseHelpButton

func _ready() -> void:
	if how_to_play_modal:
		how_to_play_modal.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")

func _on_how_to_play_pressed() -> void:
	if how_to_play_modal:
		how_to_play_modal.visible = true

func _on_close_help_pressed() -> void:
	if how_to_play_modal:
		how_to_play_modal.visible = false
