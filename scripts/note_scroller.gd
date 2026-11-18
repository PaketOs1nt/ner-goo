extends ScrollContainer

@export var scroll_step: float = 100.0
@export var scroll_speed: float = 10

var target_scroll: float = 0.0

func _ready():
	target_scroll = scroll_horizontal

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_scroll -= scroll_step
			accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_scroll += scroll_step
			accept_event()
			
		var max_scroll = get_h_scroll_bar().max_value - size.x
		target_scroll = clampf(target_scroll, 0.0, max_scroll)

func _process(delta):
	if int(scroll_horizontal) != int(target_scroll):
		var weight = 1 - exp(-scroll_speed * delta)
		scroll_horizontal = int(lerpf(float(scroll_horizontal), target_scroll, weight))
