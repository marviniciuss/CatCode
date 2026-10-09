class_name CommandTypes
extends RefCounted

const MOVE_FORWARD = "MOVE_FORWARD"
const TURN_LEFT = "TURN_LEFT"
const TURN_RIGHT = "TURN_RIGHT"
const COLLECT = "COLLECT"
const FEED = "FEED"
const LOOP = "LOOP"

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
		"color": Color("#2bd4f7"), # Ciano / Azul claro
		"description": "Repete os comandos selecionados."
	}
}

static func get_title(cmd: String) -> String:
	if COMMAND_METADATA.has(cmd):
		return COMMAND_METADATA[cmd]["title"]
	return cmd

static func get_color(cmd: String) -> Color:
	if COMMAND_METADATA.has(cmd):
		return COMMAND_METADATA[cmd]["color"]
	return Color.WHITE

static func get_description(cmd: String) -> String:
	if COMMAND_METADATA.has(cmd):
		return COMMAND_METADATA[cmd]["description"]
	return ""
