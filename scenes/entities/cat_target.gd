class_name CatTarget
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var heart_label: Label = $HeartLabel

var is_fed: bool = false
var animal_name: String = "Mia"

const TEXTURE_MIA = preload("res://assets/sprites/cutouts/cat_mia.png")
const TEXTURE_BENTO = preload("res://assets/sprites/cutouts/cat_orange.png")
const TEXTURE_LUNA = preload("res://assets/sprites/cutouts/cat_black.png")

func setup(name_id: String) -> void:
	animal_name = name_id
	is_fed = false
	if heart_label:
		heart_label.visible = false
	
	if animal_name == "Mia":
		sprite.texture = TEXTURE_MIA
	elif animal_name == "Bento":
		sprite.texture = TEXTURE_BENTO
	elif animal_name == "Luna":
		sprite.texture = TEXTURE_LUNA
	else:
		sprite.texture = TEXTURE_MIA
		
	scale = Vector2(0.42, 0.42)
	_start_idle_breathing()

func _start_idle_breathing() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "scale", Vector2(1.0, 0.94), 1.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 1.2).set_trans(Tween.TRANS_SINE)

func on_fed() -> void:
	is_fed = true
	if heart_label:
		heart_label.visible = true
		heart_label.modulate.a = 0.0
		heart_label.position.y = -60
		var h_tween = create_tween()
		h_tween.tween_property(heart_label, "modulate:a", 1.0, 0.2)
		h_tween.parallel().tween_property(heart_label, "position:y", -90, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.52, 0.52), 0.2).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(0.42, 0.42), 0.2)
