extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
var note_prev_scene = preload('res://scenes/preview_note.tscn')

@onready var file_dialog: FileDialog = $FileDialog
@onready var level_map: Control = $"../../LevelMap"
@onready var note_scroll_container: HBoxContainer = $"../../LevelMap/NoteScroller/NoteScrollContainer"
@onready var note_scroller: ScrollContainer = $"../../LevelMap/NoteScroller"


func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	file_dialog.file_selected.connect(_file_selected)

func _file_selected(path: String):
	var lvl = NGLevel.from_file(path)
	level_map.music_bin = lvl.music_bin
	level_map.music_ext = lvl.music_ext
	level_map.music_bpm = lvl.bpm
	level_map.music = lvl.music
	level_map.music_on.emit()
	level_map.note_objs.clear()
	$"../LineEditBPM".text = str(lvl.bpm)
	$"../LineEditBPM"._text_changed(str(lvl.bpm))
	$"../LineEditName".text = lvl.name
	$"../LineEditName"._text_changed(lvl.name)
	$"../ColorPicker".color = lvl.color
	var beat = 0
	while beat != lvl.end_beat:
		if beat in lvl.notes:
			var np = note_prev_scene.instantiate()
			np._main = level_map
			np.scroller = note_scroller
			note_scroll_container.add_child(np)	
			np.set_data(beat, lvl.notes[beat].pos, lvl.notes[beat].color)
			level_map.note_objs.append(np)
		else:
			var np = note_prev_scene.instantiate()
			np._main = level_map
			np.scroller = note_scroller
			note_scroll_container.add_child(np)	
			np.set_data(beat, -1, Color.WHITE)
			level_map.note_objs.append(np)
		beat += 1
		
	
func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "scale", HOVER_SCALE_TO, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _fix_pivot() -> void:
	pivot_offset = size / 2.0

func _pressed() -> void:
	Music.play_click()
	file_dialog.popup_file_dialog()
	
