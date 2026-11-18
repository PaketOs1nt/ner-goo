extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
@onready var level_map: Control = $".."

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	hide()
	level_map.music_on.connect(show)

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
	disabled = true
	modulate = Color(Color.WHITE, 0.5)
	var offset = 0.0
	if level_map.selected_note:
		offset = (60.0*level_map.selected_note.beat)/level_map.music_bpm
	level_map.music_playing = true
	$"../NotesControl".start_playing()
	Music.play_music(level_map.music, level_map.music_bpm, offset)
