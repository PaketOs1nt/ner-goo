extends TextureRect
const BEAT_Y := 25
const BEAT_Y_TO := -25
var tween: Tween
var _base_y: float

func _ready() -> void:
	_base_y = position.y
	Music.on_beat.connect(_on_beat)

func _on_beat():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	position.y = _base_y + BEAT_Y
	tween.tween_property(self, "position:y", _base_y + BEAT_Y_TO, Music.BEAT_INTERVAL*0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
