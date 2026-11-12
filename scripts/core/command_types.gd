class_name CommandTypes
extends RefCounted

const MOVE_FORWARD = "MOVE_FORWARD"
const TURN_LEFT = "TURN_LEFT"
const TURN_RIGHT = "TURN_RIGHT"
const COLLECT = "COLLECT"
const FEED = "FEED"
const LOOP = "LOOP"
const LOOP_END = "LOOP_END"

const COMMAND_METADATA = {
	MOVE_FORWARD: {
		"title": "ANDAR",
		"color": Color("#d938ff"), # Magenta / Roxo vibrante
		"description": "Move o robô 1 casa na direção para onde está olhando."
	},
	TURN_LEFT: {
		"title": "VIRE A ESQUERDA",
		"color": Color("#00c875"), # Verde
		"description": "Gira o robô 90° para a esquerda sem sair da casa."
	},
	TURN_RIGHT: {
		"title": "VIRE A DIREITA",
		"color": Color("#4568f5"), # Azul
		"description": "Gira o robô 90° para a direita sem sair da casa."
	},
	COLLECT: {
		"title": "COLETAR",
		"color": Color("#f27249"), # Laranja / Coral
		"description": "Recolhe a ração, tigela ou medicamento na casa atual."
	},
	FEED: {
		"title": "ALIMENTAR",
		"color": Color("#f73b6b"), # Vermelho / Rosa
		"description": "Alimenta ou cuida do animal acolhido na casa atual."
	},
	LOOP: {
		"title": "REPETIR (  )",
		"color": Color("#14a3c7"), # Ciano escuro / Azul turquesa
		"description": "Abre ou fecha um bloco que repete os comandos internos N vezes."
	},
	LOOP_END: {
		"title": "└ FIM REPETIR",
		"color": Color("#0e7c98"), # Ciano mais escuro para fechamento
		"description": "Marca o fim do bloco de repetição."
	}
}

static func is_loop_start(cmd: String) -> bool:
	return cmd == LOOP or cmd.begins_with("LOOP:")

static func get_loop_count(cmd: String) -> int:
	if cmd.begins_with("LOOP:"):
		var parts = cmd.split(":")
		if parts.size() > 1 and parts[1].is_valid_int():
			return clampi(parts[1].to_int(), 2, 9)
	return 3

static func make_loop_cmd(count: int) -> String:
	return "LOOP:%d" % clampi(count, 2, 9)

static func get_base_type(cmd: String) -> String:
	if is_loop_start(cmd):
		return LOOP
	return cmd

static func get_title(cmd: String) -> String:
	if is_loop_start(cmd):
		if cmd.begins_with("LOOP:"):
			return "┌ REPETIR"
		return COMMAND_METADATA[LOOP]["title"]
	if COMMAND_METADATA.has(cmd):
		return COMMAND_METADATA[cmd]["title"]
	return cmd

static func get_color(cmd: String) -> Color:
	var base = get_base_type(cmd)
	if COMMAND_METADATA.has(base):
		return COMMAND_METADATA[base]["color"]
	return Color.WHITE

static func get_description(cmd: String) -> String:
	var base = get_base_type(cmd)
	if COMMAND_METADATA.has(base):
		return COMMAND_METADATA[base]["description"]
	return ""
