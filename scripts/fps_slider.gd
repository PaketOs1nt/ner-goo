extends HSlider

@onready var fps_label: Label = $FPSLabel

func _ready() -> void:
	value_changed.connect(set_fps)

func set_fps(fps: float) -> void:
	fps_label.text = "%d FPS" % int(fps)
	Engine.max_fps = int(fps)
