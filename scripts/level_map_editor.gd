extends Control

signal select_note(n)
signal deselect_note(n)
signal music_on

var note_objs := []
var c_beat = 0
var selected_note = null
var music: AudioStream
var music_bin: PackedByteArray
var music_ext: String
var music_bpm: float
var music_turned = false
var music_playing = false
@onready var note_scroll_container: HBoxContainer = $NoteScroller/NoteScrollContainer

func _ready() -> void:
	select_note.connect(_select_note)
	music_on.connect(_music_on)

func _music_on():
	music_turned = true

func _select_note(n):
	if (not selected_note) or selected_note.beat != n.beat:
		if selected_note:
			deselect_note.emit(selected_note)
		selected_note = n
	
func recalc_beats():
	@warning_ignore("standalone_expression")
	note_objs.sort_custom(func(_n,_n1): return _n.beat < _n1.beat)
	
	var beat = 0
	for n in note_objs:
		n.beat = beat
		beat += 1
	c_beat = beat
	
	for i in range(note_objs.size()):
		note_scroll_container.move_child(note_objs[i], i)

func new_beat():
	var o = c_beat
	c_beat += 1
	return o
