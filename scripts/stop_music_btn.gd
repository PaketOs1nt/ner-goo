extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
@onready var level_map: Control = $".."
@onready var play_music_btn: TextureButton = $"../PlayMusicBtn"

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	hide()
	level_map.music_on.connect(show)
	disabled = true
	modulate = Color(Color.WHITE, 0.5)
	play_music_btn.pressed.connect(func():
		self.disabled = false
		self.modulate = Color.WHITE
	)
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
	play_music_btn.disabled = false
	play_music_btn.modulate = Color.WHITE
	disabled = true
	modulate = Color(Color.WHITE, 0.5)
	var t_beat = int(Music.player.get_playback_position()*level_map.music_bpm/60)
	if len(level_map.note_objs) > t_beat:
		level_map.select_note.emit(level_map.note_objs[t_beat])
	level_map.music_playing = false
	Music.set_default_editor_music()
