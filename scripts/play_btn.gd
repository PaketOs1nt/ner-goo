extends TextureButton

const _BEAT_SCALE := Vector2(0.9, 0.9)
const _BEAT_SCALE_TO := Vector2.ONE
const HOVER_BEAT_SCALE_TO := Vector2(1.05, 1.05)
const HOVER_BEAT_SCALE := Vector2(0.95, 0.95)
var BEAT_SCALE := _BEAT_SCALE
var BEAT_SCALE_TO := _BEAT_SCALE_TO
var tween: Tween
var tween_hover: Tween
var tween_hover1: Tween

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	Music.on_beat.connect(_on_beat)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	if tween_hover1 and tween_hover1.is_valid():
		tween_hover1.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "BEAT_SCALE_TO", HOVER_BEAT_SCALE_TO, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween_hover1 = create_tween()
	tween_hover1.tween_property(self, "BEAT_SCALE", HOVER_BEAT_SCALE, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)


func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	if tween_hover1 and tween_hover1.is_valid():
		tween_hover1.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "BEAT_SCALE_TO", _BEAT_SCALE_TO, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween_hover1 = create_tween()
	tween_hover1.tween_property(self, "BEAT_SCALE", _BEAT_SCALE, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _fix_pivot() -> void:
	pivot_offset = size / 2.0

func _on_beat():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	scale = BEAT_SCALE
	tween.tween_property(self, "scale", BEAT_SCALE_TO, Music.BEAT_INTERVAL*0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _pressed() -> void:
	Music.play_click()
	var sm = $".."
	self.disabled = true
	if $"../../Settings".active:
		$"../../Settings".close()
	sm.hide_ui(func():
		self.disabled = false
		$"../../Levels".show_ui()
	)
	
