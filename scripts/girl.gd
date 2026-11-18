extends TextureRect

const BEAT_SCALE := Vector2(1, 0.9)
const BEAT_SCALE_TO := Vector2(1, 1.1)
var tween: Tween
var _base_x: float

func _process(_d):
	position.x = _base_x + sin(Music.player.get_playback_position() * TAU / (Music.BEAT_INTERVAL*4)) * 65

func _ready() -> void:
	_base_x = position.x
	_fix_pivot()
	resized.connect(_fix_pivot)
	Music.on_beat.connect(_on_beat)

func _fix_pivot() -> void:
	pivot_offset = size

func _on_beat():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	scale = BEAT_SCALE
	tween.tween_property(self, "scale", Vector2.ONE, Music.BEAT_INTERVAL*0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
