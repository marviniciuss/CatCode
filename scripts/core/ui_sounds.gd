extends Node

const CLICK_SOUND: AudioStream = preload("res://assets/sounds/click.wav")

var _player: AudioStreamPlayer

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.stream = CLICK_SOUND
	add_child(_player)

func register_buttons(root: Node) -> void:
	if root is Button and not root.is_connected("pressed", _play_click):
		root.pressed.connect(_play_click)
	for child in root.get_children():
		register_buttons(child)

func _play_click() -> void:
	_player.play()
