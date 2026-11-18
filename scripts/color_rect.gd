extends ColorRect

const BEAT_COL := Color(1, 1, 1)
var tween: Tween

func _ready() -> void:
	Music.on_beat.connect(_on_beat)

func _on_beat():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	color = BEAT_COL
	tween.tween_property(self, "color:b", 0.33, Music.BEAT_INTERVAL*0.85).set_ease(Tween.EASE_OUT)
