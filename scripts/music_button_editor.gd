extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
@onready var music_file_dialog: FileDialog = $MusicFileDialog
@onready var level_map: Control = $"../../LevelMap"
@onready var line_edit_bpm: LineEdit = $"../LineEditBPM"

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	music_file_dialog.file_selected.connect(_file_selected)

func _file_selected(file: String):
	$Label.text = file.get_file()
	level_map.music_bin = FileAccess.get_file_as_bytes(file)
	level_map.music_ext = file.get_extension()
	level_map.music_bpm = line_edit_bpm.bpm
	level_map.music = Music.load_audio_from_buffer(level_map.music_bin, level_map.music_ext)
	level_map.music_on.emit()
	
	
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

func attention(): 
	var tw = create_tween()
	tw.tween_property(self, 'modulate', Color.RED, 0.5)
	tw.tween_callback(
		func():
			create_tween().tween_property(
				self, 'modulate', Color.WHITE, 0.5
			)
	)

func _pressed() -> void:
	Music.play_click()
	if line_edit_bpm.correct:
		music_file_dialog.popup_file_dialog()
	else:
		line_edit_bpm.attention()
	
