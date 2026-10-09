class_name Robot
extends Node2D

signal action_finished(result: Dictionary)

@onready var sprite: Sprite2D = $Sprite2D
@onready var item_badge: Sprite2D = $ItemBadge

var grid_pos: Vector2i = Vector2i.ZERO
var facing_dir: Vector2i = Vector2i.RIGHT
var is_carrying_item: bool = false
var board_ref: Node = null

var _initial_pos: Vector2i = Vector2i.ZERO
var _initial_dir: Vector2i = Vector2i.RIGHT

const TEXTURE_UP = preload("res://assets/sprites/cutouts/robot_up.png")
const TEXTURE_DOWN = preload("res://assets/sprites/cutouts/robot_down.png")
const TEXTURE_LEFT = preload("res://assets/sprites/cutouts/robot_left.png")
const TEXTURE_RIGHT = preload("res://assets/sprites/cutouts/robot_right.png")
const TEXTURE_HAPPY = preload("res://assets/sprites/cutouts/robot_happy.png")
const TEXTURE_BADGE_BOWL = preload("res://assets/sprites/cutouts/bowl_food.png")

const BASE_SCALE = Vector2(0.40, 0.40)

func setup(start_pos: Vector2i, start_dir: Vector2i, board: Node) -> void:
	board_ref = board
	_initial_pos = start_pos
	_initial_dir = start_dir
	reset_to_start()

func reset_to_start() -> void:
	grid_pos = _initial_pos
	facing_dir = _initial_dir
	is_carrying_item = false
	
	if item_badge:
		item_badge.visible = false
	
	if board_ref and board_ref.has_method("grid_to_world"):
		position = board_ref.grid_to_world(grid_pos)
		
	_update_sprite_direction()
	scale = BASE_SCALE

func _update_sprite_direction() -> void:
	if not sprite:
		return
	if facing_dir == Vector2i(0, 1): # Baixo
		sprite.texture = TEXTURE_DOWN
	elif facing_dir == Vector2i(0, -1): # Cima
		sprite.texture = TEXTURE_UP
	elif facing_dir == Vector2i(-1, 0): # Esquerda
		sprite.texture = TEXTURE_LEFT
	elif facing_dir == Vector2i(1, 0): # Direita
		sprite.texture = TEXTURE_RIGHT
	else:
		sprite.texture = TEXTURE_DOWN

func turn_left() -> void:
	# Sentido anti-horário: (1, 0) -> (0, -1) -> (-1, 0) -> (0, 1)
	facing_dir = Vector2i(facing_dir.y, -facing_dir.x)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", BASE_SCALE * Vector2(0.8, 1.25), 0.1).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	_update_sprite_direction()
	
	var bounce = create_tween()
	bounce.tween_property(self, "scale", BASE_SCALE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await bounce.finished
	
	action_finished.emit({ "action": "turn_left", "success": true })

func turn_right() -> void:
	# Sentido horário: (1, 0) -> (0, 1) -> (-1, 0) -> (0, -1)
	facing_dir = Vector2i(-facing_dir.y, facing_dir.x)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", BASE_SCALE * Vector2(0.8, 1.25), 0.1).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	_update_sprite_direction()
	
	var bounce = create_tween()
	bounce.tween_property(self, "scale", BASE_SCALE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await bounce.finished
	
	action_finished.emit({ "action": "turn_right", "success": true })

func move_forward() -> void:
	var next_pos = grid_pos + facing_dir
	
	if not board_ref:
		action_finished.emit({ "action": "move", "success": false, "reason": "no_board" })
		return
	
	if not board_ref.is_valid_cell(next_pos):
		await _play_bump_animation()
		action_finished.emit({ "action": "move", "success": false, "reason": "bump_edge", "pos": next_pos })
		return
		
	if board_ref.is_obstacle(next_pos):
		await _play_bump_animation()
		action_finished.emit({ "action": "move", "success": false, "reason": "bump_obstacle", "pos": next_pos })
		return
	
	# Movimento válido para a próxima casa
	grid_pos = next_pos
	var target_world = board_ref.grid_to_world(grid_pos)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", target_world, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	# Passinho suave com estiramento e compressão
	var anim_tween = create_tween()
	anim_tween.tween_property(self, "scale", BASE_SCALE * Vector2(1.15, 0.88), 0.14)
	anim_tween.tween_property(self, "scale", BASE_SCALE, 0.14)
	
	await tween.finished
	action_finished.emit({ "action": "move", "success": true, "pos": grid_pos })

func collect() -> void:
	if not board_ref:
		action_finished.emit({ "action": "collect", "success": false, "reason": "no_board" })
		return

	# Checa se o robô está na casa da ração/tigela e ainda não a pegou
	if grid_pos == board_ref.food_pos and board_ref.has_food and not is_carrying_item:
		is_carrying_item = true
		board_ref.remove_food()
		
		if item_badge:
			item_badge.visible = true
			item_badge.texture = TEXTURE_BADGE_BOWL
			item_badge.scale = Vector2(0.28, 0.28)
		
		# Animação do robô feliz comemorando a coleta
		sprite.texture = TEXTURE_HAPPY
		var tween = create_tween()
		tween.tween_property(self, "scale", BASE_SCALE * 1.3, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", BASE_SCALE, 0.14)
		await tween.finished
		_update_sprite_direction()
		
		action_finished.emit({ "action": "collect", "success": true, "event": "collected" })
		return

	# Nada para coletar aqui
	await _play_shake_animation()
	action_finished.emit({
		"action": "collect",
		"success": false,
		"reason": "nothing_to_collect",
		"is_carrying": is_carrying_item
	})

func feed() -> void:
	if not board_ref:
		action_finished.emit({ "action": "feed", "success": false, "reason": "no_board" })
		return

	# Checa se o robô está na casa do animal acolhido e com o item em mãos
	if grid_pos == board_ref.animal_pos:
		if is_carrying_item:
			is_carrying_item = false
			board_ref.feed_animal()
			if item_badge:
				item_badge.visible = false
				
			sprite.texture = TEXTURE_HAPPY
			var tween = create_tween()
			tween.tween_property(self, "scale", BASE_SCALE * 1.35, 0.22).set_trans(Tween.TRANS_BACK)
			tween.tween_property(self, "scale", BASE_SCALE, 0.16)
			await tween.finished
			
			action_finished.emit({ "action": "feed", "success": true, "event": "fed" })
			return
		else:
			await _play_shake_animation()
			action_finished.emit({ "action": "feed", "success": false, "reason": "no_food_in_hands" })
			return

	# Não está na casa do animal
	await _play_shake_animation()
	action_finished.emit({ "action": "feed", "success": false, "reason": "not_at_animal" })

func _play_bump_animation() -> void:
	var bump_vector = Vector2(facing_dir.x, facing_dir.y) * 16.0
	var orig_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", orig_pos + bump_vector, 0.08)
	tween.tween_property(self, "position", orig_pos, 0.14).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished

func _play_shake_animation() -> void:
	var orig_x = position.x
	var tween = create_tween()
	tween.tween_property(self, "position:x", orig_x - 8, 0.06)
	tween.tween_property(self, "position:x", orig_x + 8, 0.06)
	tween.tween_property(self, "position:x", orig_x, 0.06)
	await tween.finished
