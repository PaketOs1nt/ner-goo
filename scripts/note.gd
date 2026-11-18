extends ColorRect

var action: Signal
var pos: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tap"):
		if event is InputEventKey and event.is_echo():
			return
		if get_global_rect().has_point(get_global_mouse_position()):
			action.emit(pos, Music.m_pos)
			get_viewport().set_input_as_handled()
