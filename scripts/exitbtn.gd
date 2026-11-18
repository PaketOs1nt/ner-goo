extends TextureButton

const oneone := Vector2(1.1, 1.1)

func _pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)

func _fix_pivot() -> void:
	pivot_offset = size / 2.0

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered():
		scale = oneone
	elif scale == oneone:
		scale = Vector2.ONE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().quit()
