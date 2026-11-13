class_name LevelData
extends Resource

static var selected_level_index: int = 0
static var max_unlocked_level: int = 1

static func unlock_next_level(completed_level_index: int) -> void:
	var total_levels = get_default_levels().size()
	var next_level_num = completed_level_index + 2
	if next_level_num <= total_levels and next_level_num > max_unlocked_level:
		max_unlocked_level = next_level_num

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
	
static func _walls_around(path: Array, w: int, h: int) -> Array:
	var walls: Array = []
	for p in path:
		for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var n: Vector2i = p + d
			if n.x < 0 or n.y < 0 or n.x >= w or n.y >= h:
				continue
			if n in path or n in walls:
				continue
			walls.append(n)
	return walls

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

	# --- FASE 4: Cenário 2 (Exploração - Introdução ao Bloco REPETIR) ---
	var l4 = LevelData.new()
	l4.level_id = "c2_l1"
	l4.level_number = 4
	l4.scenario_name = "Cenário 2 — Exploração com Laços"
	l4.target_animal_name = "Bento"
	l4.difficulty = "Médio"
	l4.title = "Fase 4: O Atalho Repetitivo"
	l4.mission_text = "Use o novo bloco REPETIR para economizar comandos! Pegue a ração no corredor e desça até o Bento."
	l4.grid_width = 6
	l4.grid_height = 6
	l4.robot_start_pos = Vector2i(0, 0)
	l4.robot_start_dir = Vector2i(1, 0) # Direita
	l4.food_pos = Vector2i(4, 0)
	l4.animal_pos = Vector2i(1, 3)
	l4.obstacles = [
		Vector2i(0, 1),
		Vector2i(1, 1),
		Vector2i(2, 1),
		Vector2i(5, 2)
	]
	l4.decorative_tiles = {
		Vector2i(3, 3): "stone",
		Vector2i(4, 3): "stone"
	}
	l4.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.FEED
	]
	l4.max_commands = 20
	levels.append(l4)
	
		# --- FASE 5: A Escadinha do Bento ---
	var l5 = LevelData.new()
	l5.level_id = "c2_l2"
	l5.level_number = 5
	l5.scenario_name = "Cenário 2 — Exploração com Laços"
	l5.target_animal_name = "Bento"
	l5.difficulty = "Difícil"
	l5.title = "Fase 5: A Escadinha do Bento"
	l5.mission_text = "Pegue a ração e leve até o Bento! Descubra o padrão da escada e use REPETIR. Você tem até 12 blocos."

	l5.grid_width = 6
	l5.grid_height = 6

	l5.robot_start_pos = Vector2i(0, 5)
	l5.robot_start_dir = Vector2i(1, 0)
	l5.food_pos = Vector2i(4, 1)
	l5.animal_pos = Vector2i(5, 0)

	l5.obstacles = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
		Vector2i(3, 0), Vector2i(4, 0),

		Vector2i(0, 1), Vector2i(1, 1),
		Vector2i(2, 1), Vector2i(3, 1),

		Vector2i(0, 2), Vector2i(1, 2),
		Vector2i(2, 2), Vector2i(5, 2),

		Vector2i(0, 3), Vector2i(1, 3),
		Vector2i(4, 3), Vector2i(5, 3),

		Vector2i(0, 4), Vector2i(3, 4),
		Vector2i(4, 4), Vector2i(5, 4),

		Vector2i(2, 5), Vector2i(3, 5),
		Vector2i(4, 5), Vector2i(5, 5)
	]

	l5.decorative_tiles = {}

	l5.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.FEED
	]

	l5.max_commands = 12
	levels.append(l5)

	# --- FASE 6: Cenário 2 (Tomada de Decisão - Introdução ao Bloco SE) ---
	var l6 = LevelData.new()
	l6.level_id = "c2_l3"
	l6.level_number = 6
	l6.scenario_name = "Cenário 2 — Decisões Inteligentes"
	l6.target_animal_name = "Luna"
	l6.difficulty = "Difícil"
	l6.title = "Fase 6: O Corredor Inteligente"
	l6.mission_text = "Use o bloco SE dentro do REPETIR! Se estiver sobre a ração, colete; se houver obstáculo à frente, vire à direita até chegar na Luna."
	l6.grid_width = 6
	l6.grid_height = 6
	l6.robot_start_pos = Vector2i(1, 0)
	l6.robot_start_dir = Vector2i(1, 0) # Direita
	l6.food_pos = Vector2i(2, 0)
	l6.animal_pos = Vector2i(3, 2)
	l6.obstacles = [
		Vector2i(0, 0), Vector2i(5, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(5, 1),
		Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(5, 2),
		Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(5, 3),
		Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4),
		Vector2i(0, 5), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(4, 5), Vector2i(5, 5)
	]
	l6.decorative_tiles = {
		Vector2i(4, 3): "stone"
	}
	l6.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.IF_COND,
		CommandTypes.FEED
	]
	l6.max_commands = 9
	levels.append(l6)

	# --- FASE 7: Cenário 3 (Caminho em "S" - Combinando Laços e Condicionais) ---
	var l7 = LevelData.new()
	l7.level_id = "c3_l1"
	l7.level_number = 7
	l7.scenario_name = "Cenário 3 — Desafio de Lógica"
	l7.target_animal_name = "Luna"
	l7.difficulty = "Difícil"
	l7.title = "Fase 7: A Serpentina da Luna"
	l7.mission_text = "O caminho faz curvas para lados opostos! Combine dois blocos REPETIR com o SE para buscar a ração e chegar até a Luna."
	l7.grid_width = 6
	l7.grid_height = 6
	l7.robot_start_pos = Vector2i(0, 0)
	l7.robot_start_dir = Vector2i(1, 0) # Direita
	l7.food_pos = Vector2i(2, 2)
	l7.animal_pos = Vector2i(3, 4)
	l7.obstacles = [
		Vector2i(4, 0), Vector2i(5, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(4, 1), Vector2i(5, 1),
		Vector2i(4, 2), Vector2i(5, 2),
		Vector2i(0, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3),
		Vector2i(0, 4), Vector2i(4, 4), Vector2i(5, 4),
		Vector2i(0, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(4, 5), Vector2i(5, 5)
	]
	l7.decorative_tiles = {
		Vector2i(0, 2): "stone",
		Vector2i(1, 5): "stone"
	}
	l7.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.IF_COND,
		CommandTypes.FEED
	]
	l7.max_commands = 14
	levels.append(l7)
	
	var l8 = LevelData.new()
	l8.level_id = "c3_l2"
	l8.level_number = 8
	l8.scenario_name = "Cenário 3 — Desafio de Lógica"
	l8.target_animal_name = "Mia"
	l8.difficulty = "Difícil"
	l8.title = "Fase 8: O Beco da Mia"
	l8.mission_text = "A ração está num beco sem saída! Use SE / SENÃO dentro do REPETIR: se houver obstáculo, vire à direita; senão, ande. Colete a ração e leve até a Mia."
	l8.grid_width = 6
	l8.grid_height = 6
	var path8 = [Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3), Vector2i(3, 1)]
	l8.robot_start_pos = Vector2i(2, 1)
	l8.robot_start_dir = Vector2i(0, 1) 
	l8.food_pos = Vector2i(2, 3)
	l8.animal_pos = Vector2i(3, 1)
	l8.obstacles = _walls_around(path8, 6, 6)
	l8.decorative_tiles = {}
	l8.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.IF_COND,
		CommandTypes.ELSE,
		CommandTypes.FEED
	]
	l8.max_commands = 9
	levels.append(l8)

	var l9 = LevelData.new()
	l9.level_id = "c3_l3"
	l9.level_number = 9
	l9.scenario_name = "Cenário 3 — Desafio de Lógica"
	l9.target_animal_name = "Bento"
	l9.difficulty = "Difícil"
	l9.title = "Fase 9: O Caminho do Bento"
	l9.mission_text = "O caminho tem curvas, e o robô precisa reagir ao que encontra! Use ESCOLHA com vários CASOS: coletar a ração, virar quando houver obstáculo e andar nos outros casos. Atenção: a ordem dos casos importa!"
	l9.grid_width = 6
	l9.grid_height = 6
	var path9 = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0),
		Vector2i(4, 1), Vector2i(4, 2), Vector2i(4, 3),
		Vector2i(3, 3), Vector2i(2, 3), Vector2i(1, 3),
		Vector2i(1, 2)
	]
	l9.robot_start_pos = Vector2i(0, 0)
	l9.robot_start_dir = Vector2i(1, 0) 
	l9.food_pos = Vector2i(4, 2)
	l9.animal_pos = Vector2i(1, 2)
	l9.obstacles = _walls_around(path9, 6, 6)
	l9.decorative_tiles = {}
	l9.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.UNTIL,
		CommandTypes.SWITCH,
		CommandTypes.CASE,
		CommandTypes.FEED
	]
	l9.max_commands = 10
	levels.append(l9)

	var l10 = LevelData.new()
	l10.level_id = "c3_l4"
	l10.level_number = 10
	l10.scenario_name = "Cenário 3 — Desafio de Lógica"
	l10.target_animal_name = "Luna"
	l10.difficulty = "Difícil"
	l10.title = "Fase 10: Os Degraus da Luna"
	l10.mission_text = "Os degraus se repetem, mas com trechos retos entre eles! Ensine uma manobra ao robô com DEFINIR e use CHAMAR sempre que precisar."
	l10.grid_width = 6
	l10.grid_height = 6
	var path10 = [
		Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1),
		Vector2i(3, 2), Vector2i(4, 2), Vector2i(4, 3), Vector2i(5, 3)
	]
	l10.robot_start_pos = Vector2i(0, 0)
	l10.robot_start_dir = Vector2i(1, 0) 
	l10.food_pos = Vector2i(3, 1)
	l10.animal_pos = Vector2i(5, 3)
	l10.obstacles = _walls_around(path10, 6, 6)
	l10.decorative_tiles = {}
	l10.allowed_commands = [
		CommandTypes.MOVE_FORWARD,
		CommandTypes.TURN_LEFT,
		CommandTypes.TURN_RIGHT,
		CommandTypes.COLLECT,
		CommandTypes.LOOP,
		CommandTypes.FUNC_DEF,
		CommandTypes.FUNC_CALL,
		CommandTypes.FEED
	]
	l10.max_commands = 13
	levels.append(l10)
	
	return levels
