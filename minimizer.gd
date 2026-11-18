extends Node

var win: Window

func _enter_tree() -> void:
	win = get_window()
	win.focus_entered.connect(
		func():
			if not win.has_focus():
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	)

func _process(_d: float) -> void:
	if win.has_focus():
		Music.player.volume_linear = 1.0
	else:
		Music.player.volume_linear = 0.0

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("windows"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		get_viewport().set_input_as_handled()
