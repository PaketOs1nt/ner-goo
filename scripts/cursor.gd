extends Sprite2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	top_level = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = event.position

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
