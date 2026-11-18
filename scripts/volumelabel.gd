class_name VolumeLabel
extends Label

var timer: Timer

func _ready() -> void:
	var font = load('res://PermanentMarker.ttf')
	add_theme_constant_override("outline_size", 32)
	add_theme_font_override("font", font)
	add_theme_font_size_override("font_size", 100)
	position.y = 455
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(hide)
	hide()

func set_volume(v: int):
	show()
	text = str(v)
	timer.set_wait_time(1.0)
	timer.start()
