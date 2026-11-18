extends TextureRect

@onready var timer: Timer = $Timer

func _process(_d: float) -> void:
	var c = sin(timer.time_left*TAU)
	texture.gradient.set_color(1, Color(c, c, c))
