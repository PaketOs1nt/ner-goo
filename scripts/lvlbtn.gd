extends Button

var base_x: float
var tween: Tween

func _ready() -> void:
	base_x = position.x
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", base_x-75, 0.3)

func _on_mouse_exited() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", base_x, 0.3)

func _pressed() -> void:
	if not $".."._creator.lvls_disabled:
		Music.play_click()
		$"..".play()
