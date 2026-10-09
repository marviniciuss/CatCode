@tool
class_name GridBoard
extends Node2D

signal food_collected
signal animal_fed

@export var tile_size: float = 90.0:
	set(val):
		tile_size = val
		if Engine.is_editor_hint():
			build_grid()

@onready var background_rect: ColorRect = $BackgroundRect
@onready var tiles_container: Node2D = $Tiles
@onready var grid_lines: GridLines = $GridLines
@onready var items_container: Node2D = $Items
@onready var obstacles_container: Node2D = $Obstacles
@onready var entities_container: Node2D = $Entities

@export var grid_width: int = 6:
	set(val):
		grid_width = val
		if Engine.is_editor_hint():
			build_grid()

@export var grid_height: int = 6:
	set(val):
		grid_height = val
		if Engine.is_editor_hint():
			build_grid()

var food_pos: Vector2i = Vector2i(4, 1)
var animal_pos: Vector2i = Vector2i(5, 4)
var obstacles: Array = [Vector2i(2, 2)]
var decorative_tiles: Dictionary = { Vector2i(4, 4): "stone" }

var has_food: bool = true
var is_animal_fed: bool = false

var food_sprite: Sprite2D = null
var animal_entity: CatTarget = null

const TEXTURE_BOWL = preload("res://assets/sprites/cutouts/bowl_food.png")
const TEXTURE_BUSH_WHITE = preload("res://assets/sprites/cutouts/bush_white.png")
const TEXTURE_STONE = preload("res://assets/sprites/cutouts/tile_stone.png")
const CAT_TARGET_SCENE = preload("res://scenes/entities/cat_target.tscn")

func _ready() -> void:
	if Engine.is_editor_hint():
		build_grid()

func setup_level(data: LevelData) -> void:
	grid_width = data.grid_width
	grid_height = data.grid_height
	food_pos = data.food_pos
	animal_pos = data.animal_pos
	obstacles = data.obstacles.duplicate()
	decorative_tiles = data.decorative_tiles.duplicate()
	
	build_grid()
	reset_board_state()

func reset_board_state() -> void:
	has_food = true
	is_animal_fed = false
	
	if food_sprite:
		food_sprite.visible = true
		food_sprite.scale = Vector2(0.42, 0.42)
	
	if animal_entity:
		animal_entity.setup(animal_entity.animal_name)

func build_grid() -> void:
	if not tiles_container or not obstacles_container or not items_container or not entities_container:
		return
		
	# Limpar elementos anteriores
	for child in tiles_container.get_children():
		child.queue_free()
	for child in obstacles_container.get_children():
		child.queue_free()
	for child in items_container.get_children():
		child.queue_free()
	for child in entities_container.get_children():
		child.queue_free()
	
	# Dimensionar fundo verde
	var total_w = grid_width * tile_size
	var total_h = grid_height * tile_size
	
	if background_rect:
		background_rect.position = Vector2(-total_w / 2.0, -total_h / 2.0)
		background_rect.size = Vector2(total_w, total_h)
	
	# Configurar e redesenhar as linhas da grade
	if grid_lines:
		grid_lines.setup(grid_width, grid_height, tile_size)
	
	# Adicionar tiles decorativos (ex: pedra de calçamento em (4, 4))
	for cell_pos in decorative_tiles.keys():
		var tile_type = decorative_tiles[cell_pos]
		if tile_type == "stone":
			var tile = Sprite2D.new()
			tile.texture = TEXTURE_STONE
			tile.position = grid_to_world(cell_pos)
			tile.scale = Vector2(tile_size / 154.0, tile_size / 149.0)
			tiles_container.add_child(tile)
	
	# Criar arbustos / obstáculos
	for obs_pos in obstacles:
		var obs = Sprite2D.new()
		obs.texture = TEXTURE_BUSH_WHITE
		obs.position = grid_to_world(obs_pos)
		obs.scale = Vector2(0.50, 0.50)
		obstacles_container.add_child(obs)
	
	# Criar tigela de ração
	if food_pos.x >= 0 and food_pos.y >= 0:
		food_sprite = Sprite2D.new()
		food_sprite.texture = TEXTURE_BOWL
		food_sprite.position = grid_to_world(food_pos)
		food_sprite.scale = Vector2(0.42, 0.42)
		items_container.add_child(food_sprite)
		if not Engine.is_editor_hint():
			_animate_food_pulse()
	
	# Criar gatinha Mia / animal acolhido
	if animal_pos.x >= 0 and animal_pos.y >= 0:
		animal_entity = CAT_TARGET_SCENE.instantiate() as CatTarget
		animal_entity.position = grid_to_world(animal_pos)
		entities_container.add_child(animal_entity)
		animal_entity.setup("Mia")

func _animate_food_pulse() -> void:
	if not food_sprite:
		return
	var tween = create_tween().set_loops()
	tween.tween_property(food_sprite, "scale", Vector2(0.46, 0.46), 0.75).set_trans(Tween.TRANS_SINE)
	tween.tween_property(food_sprite, "scale", Vector2(0.40, 0.40), 0.75).set_trans(Tween.TRANS_SINE)

func grid_to_world(grid: Vector2i) -> Vector2:
	var total_w = grid_width * tile_size
	var total_h = grid_height * tile_size
	var top_left = Vector2(-total_w / 2.0 + tile_size / 2.0, -total_h / 2.0 + tile_size / 2.0)
	return top_left + Vector2(grid.x * tile_size, grid.y * tile_size)

func is_valid_cell(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < grid_width and pos.y >= 0 and pos.y < grid_height

func is_obstacle(pos: Vector2i) -> bool:
	return pos in obstacles

func remove_food() -> void:
	has_food = false
	if food_sprite:
		var tween = create_tween()
		tween.tween_property(food_sprite, "scale", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		await tween.finished
		food_sprite.visible = false
	food_collected.emit()

func feed_animal() -> void:
	is_animal_fed = true
	if animal_entity:
		animal_entity.on_fed()
	animal_fed.emit()
