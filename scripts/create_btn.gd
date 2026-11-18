extends TextureButton

var tween: Tween
var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
var base_x: float

var editor_scene = preload("res://scenes/editor.tscn")

func _ready() -> void:
	base_x = position.x
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	Music.on_beat.connect(_on_beat)

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

func _on_beat():
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	position.x = base_x + 25
	tween.tween_property(self, "position:x", base_x, Music.BEAT_INTERVAL*0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _pressed() -> void:
	Music.play_click()
	disabled = true
	var tw = create_tween()
	tw.tween_property($"../..", 'modulate', Color.BLACK, 1)
	await tw.finished
	disabled = false
	get_tree().change_scene_to_packed(editor_scene)
