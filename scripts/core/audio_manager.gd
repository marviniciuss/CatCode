class_name AudioManager
extends Node

const STREAM_THEME = preload("res://assets/songs/musica_tema.mp3")
const STREAM_MATCH = preload("res://assets/songs/musica_partida.mp3")
const STREAM_COLLECT = preload("res://assets/songs/som_coleta.mp3")
const STREAM_GAME_OVER = preload("res://assets/songs/game_over.mp3")

static var _instance: AudioManager = null

var bgm_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null
var _current_bgm: AudioStream = null

static func _get_instance() -> AudioManager:
	if is_instance_valid(_instance):
		return _instance
	var main_loop = Engine.get_main_loop()
	if main_loop is SceneTree:
		var tree := main_loop as SceneTree
		var existing = tree.root.get_node_or_null("AudioManager")
		if existing is AudioManager:
			_instance = existing
			return _instance
		var mgr = AudioManager.new()
		mgr.name = "AudioManager"
		mgr._setup_players()
		tree.root.call_deferred("add_child", mgr)
		_instance = mgr
		return _instance
	return null

func _ready() -> void:
	_setup_players()

func _setup_players() -> void:
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		bgm_player.name = "BGMPlayer"
		bgm_player.volume_db = -4.0
		add_child(bgm_player)
	if not sfx_player:
		sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer"
		bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS
		sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(sfx_player)

func _play_bgm(stream: AudioStream) -> void:
	_setup_players()
	if sfx_player.playing and sfx_player.stream == STREAM_GAME_OVER:
		sfx_player.stop()
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
	if _current_bgm == stream and bgm_player.playing:
		return
	_current_bgm = stream
	bgm_player.stream = stream
	bgm_player.play()

func _play_sfx(stream: AudioStream, stop_bgm: bool = false) -> void:
	_setup_players()
	if stop_bgm:
		bgm_player.stop()
		_current_bgm = null
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = false
	sfx_player.stop()
	sfx_player.stream = stream
	sfx_player.play()

static func play_theme_music() -> void:
	var mgr = _get_instance()
	if mgr:
		mgr.call_deferred("_play_bgm", STREAM_THEME)

static func play_match_music() -> void:
	var mgr = _get_instance()
	if mgr:
		mgr.call_deferred("_play_bgm", STREAM_MATCH)

static func play_collect_sfx() -> void:
	var mgr = _get_instance()
	if mgr:
		mgr.call_deferred("_play_sfx", STREAM_COLLECT, false)

static func play_game_over_sfx() -> void:
	var mgr = _get_instance()
	if mgr:
		mgr.call_deferred("_play_sfx", STREAM_GAME_OVER, true)

