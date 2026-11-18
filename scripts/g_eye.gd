extends TextureRect

@onready var g_head: TextureRect = $"../GHead"
var base_pos: Vector2
var target: Vector2
func _ready() -> void:
	base_pos = position

func _process(d: float) -> void:
	var pos := base_pos
	target = pos + (get_global_mouse_position()-(pos+(size/2))).limit_length(50.0)
	position += (target-position)/(0.06/d)
