@tool
class_name GridLines
extends Node2D

@export var grid_width: int = 6:
	set(val):
		grid_width = val
		queue_redraw()

@export var grid_height: int = 6:
	set(val):
		grid_height = val
		queue_redraw()

@export var tile_size: float = 90.0:
	set(val):
		tile_size = val
		queue_redraw()

@export var line_color: Color = Color(0.16, 0.28, 0.22, 1.0):
	set(val):
		line_color = val
		queue_redraw()

@export var line_width: float = 2.0:
	set(val):
		line_width = val
		queue_redraw()

func setup(w: int, h: int, size: float) -> void:
	grid_width = w
	grid_height = h
	tile_size = size
	queue_redraw()

func _draw() -> void:
	var total_w = grid_width * tile_size
	var total_h = grid_height * tile_size
	var top_left = Vector2(-total_w / 2.0, -total_h / 2.0)
	
	# Linhas verticais
	for x in range(grid_width + 1):
		var p1 = top_left + Vector2(x * tile_size, 0)
		var p2 = top_left + Vector2(x * tile_size, total_h)
		draw_line(p1, p2, line_color, line_width, true)
		
	# Linhas horizontais
	for y in range(grid_height + 1):
		var p1 = top_left + Vector2(0, y * tile_size)
		var p2 = top_left + Vector2(total_w, y * tile_size)
		draw_line(p1, p2, line_color, line_width, true)
