extends Node

var sounds = {
	"hit": preload("res://hitnormal.ogg"),
	"click": preload("res://menuclick.ogg") 
}

var sounds_db = {
	"hit": 0,
	"click": 3
}

@onready var default_stream = preload("res://Pixel Peeker Polka - slower.mp3")
@onready var default_editor_stream = preload("res://March-of-the-spoons-by-Kevin-Macleod.mp3")

var BPM: float = 0
var BEAT_INTERVAL: float = 0
var player: AudioStreamPlayer 
var sfxpools = {}
const POOL_SIZE = 16
var m_pos: float
signal on_beat

var sfx_bus_id = AudioServer.get_bus_index("SFX")
var music_bus_id = AudioServer.get_bus_index("Music")
var master_bus_id = AudioServer.get_bus_index("Master")

var last_beat := -1
var vlabel: VolumeLabel

func _ready():
	var ui_layer = CanvasLayer.new()
	ui_layer.layer = 100
	vlabel = VolumeLabel.new()
	vlabel.position = Vector2.ONE
	
	ui_layer.add_child(vlabel)
	get_tree().root.add_child.call_deferred(ui_layer)
	
	
	default_stream.loop =  true
	default_editor_stream.loop = true
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)

	for sfx_n in sounds: 
		sfxpools[sfx_n] = []
		for _i in range(POOL_SIZE):
			var sfx_player = AudioStreamPlayer.new()
			sfx_player.stream = sounds[sfx_n]
			sfx_player.volume_db = sounds_db[sfx_n]
			sfx_player.bus = "SFX" 
			add_child(sfx_player)
			sfxpools[sfx_n].append(sfx_player)

func set_default_music():
	Music.play_music(default_stream, 128.0)
	
func set_default_editor_music():
	Music.play_music(default_editor_stream, 85.0)

func play_music(stream: AudioStream, bpm: float, offset: float = 0.0):
	BPM = bpm
	BEAT_INTERVAL = 60.0/bpm
	last_beat = -1
	player.stop() 
	player.stream = stream
	player.play(offset)
		
func play_sfx(sfx_name: String, pitch: float = 1.0):
	for s_player in sfxpools[sfx_name]:
		if not s_player.playing:
			s_player.pitch_scale = pitch
			s_player.play()
			return

func play_click():
	play_sfx('click', 1+randf_range(-0.1, 0.1))
	
func play_hit():
	play_sfx('hit', 1+randf_range(-0.1, 0.1))

func _process(_d):
	m_pos = Music.player.get_playback_position()+AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var beat := int(m_pos / Music.BEAT_INTERVAL)
	if beat < 0:
		return
	if beat < last_beat:
		last_beat = -1 
	if beat > last_beat:
		for b in range(last_beat + 1, beat + 1):
			last_beat = b
			on_beat.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var nv = clamp(round(AudioServer.get_bus_volume_linear(master_bus_id)*100)+1,0,100)
			AudioServer.set_bus_volume_linear(
				master_bus_id,
				float(nv)/100.0
			)
			vlabel.set_volume(nv)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var nv = clamp(round(AudioServer.get_bus_volume_linear(master_bus_id)*100)-1,0,100)
			AudioServer.set_bus_volume_linear(
				master_bus_id,
				float(nv)/100.0
			)
			vlabel.set_volume(nv)


func load_audio_from_buffer(buf: PackedByteArray, ext: String) -> AudioStream:
	match ext:
		"ogg":
			return AudioStreamOggVorbis.load_from_buffer(buf)
		"mp3":
			return AudioStreamMP3.load_from_buffer(buf)
		"wav":
			return AudioStreamWAV.load_from_buffer(buf)
		_:
			return null
