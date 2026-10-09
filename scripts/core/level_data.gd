class_name LevelData
extends Resource

@export var level_id: String = "c1_l1"
@export var level_number: int = 1
@export var scenario_name: String = "Cenário 1 — Alimentação"
@export var target_animal_name: String = "Mia"
@export var difficulty: String = "Fácil"
@export var title: String = "Fase 1: O Lanchinho da Mia"
@export_multiline var mission_text: String = "O gatinho está com fome! Ajude o robô a pegar a comida e levá-la até ele."

@export var grid_width: int = 6
@export var grid_height: int = 6

@export var robot_start_pos: Vector2i = Vector2i(0, 0)
@export var robot_start_dir: Vector2i = Vector2i(1, 0) # Direita

@export var food_pos: Vector2i = Vector2i(4, 1)
@export var animal_pos: Vector2i = Vector2i(5, 4)
@export var obstacles: Array = [Vector2i(2, 2)]
@export var decorative_tiles: Dictionary = { Vector2i(4, 4): "stone" }

@export var allowed_commands: Array = []
@export var max_commands: int = 24

func _init() -> void:
	allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.FEED
	]

static func get_default_levels() -> Array[LevelData]:
	var levels: Array[LevelData] = []

	# --- FASE 1: Cenário 1 (Alimentação - Mia) - Idêntica à cena_principal.png ---
	var l1 = LevelData.new()
	l1.level_id = "c1_l1"
	l1.level_number = 1
	l1.scenario_name = "Cenário 1 — Alimentação"
	l1.target_animal_name = "Mia"
	l1.difficulty = "Fácil"
	l1.title = "Fase 1: Acolhendo a Mia"
	l1.mission_text = "O gatinho está com fome! Ajude o robô a pegar a comida e levá-la até ele."
	l1.grid_width = 6
	l1.grid_height = 6
	l1.robot_start_pos = Vector2i(0, 0)
	l1.robot_start_dir = Vector2i(1, 0) # Direita
	l1.food_pos = Vector2i(4, 1)
	l1.animal_pos = Vector2i(5, 4)
	l1.obstacles = [Vector2i(2, 2)]
	l1.decorative_tiles = { Vector2i(4, 4): "stone" }
	l1.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.FEED
	]
	l1.max_commands = 20
	levels.append(l1)

	# --- FASE 2: Cenário 1 (Alimentação - Desvio com mais obstáculos) ---
	var l2 = LevelData.new()
	l2.level_id = "c1_l2"
	l2.level_number = 2
	l2.scenario_name = "Cenário 1 — Alimentação"
	l2.target_animal_name = "Mia"
	l2.difficulty = "Médio"
	l2.title = "Fase 2: Desviando dos Arbustos"
	l2.mission_text = "O caminho tem mais arbustos! Conduza o robô até o alimento e depois alimente a gatinha Mia."
	l2.grid_width = 6
	l2.grid_height = 6
	l2.robot_start_pos = Vector2i(0, 0)
	l2.robot_start_dir = Vector2i(1, 0)
	l2.food_pos = Vector2i(5, 1)
	l2.animal_pos = Vector2i(1, 5)
	l2.obstacles = [
		Vector2i(2, 1),
		Vector2i(2, 2),
		Vector2i(3, 4),
		Vector2i(4, 4)
	]
	l2.decorative_tiles = { Vector2i(1, 1): "stone", Vector2i(3, 3): "stone" }
	l2.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.FEED
	]
	l2.max_commands = 25
	levels.append(l2)

	# --- FASE 3: Cenário 1 (Alimentação - Bento / Obstáculos do Pátio) ---
	var l3 = LevelData.new()
	l3.level_id = "c1_l3"
	l3.level_number = 3
	l3.scenario_name = "Cenário 1 — Alimentação"
	l3.target_animal_name = "Bento"
	l3.difficulty = "Médio"
	l3.title = "Fase 3: O Pátio do Bento"
	l3.mission_text = "O cãozinho Bento está do outro lado do abrigo! Busque a água fresca e leve até ele desviando das árvores."
	l3.grid_width = 6
	l3.grid_height = 6
	l3.robot_start_pos = Vector2i(0, 5)
	l3.robot_start_dir = Vector2i(0, -1) # Cima
	l3.food_pos = Vector2i(2, 1)
	l3.animal_pos = Vector2i(5, 5)
	l3.obstacles = [
		Vector2i(1, 3),
		Vector2i(2, 3),
		Vector2i(3, 3),
		Vector2i(4, 2)
	]
	l3.decorative_tiles = { Vector2i(2, 2): "stone", Vector2i(5, 4): "stone" }
	l3.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.FEED
	]
	l3.max_commands = 30
	levels.append(l3)

	return levels
