extends Node2D

func _ready() -> void:
	Music.set_default_editor_music()
	
func _enter_tree() -> void:
	modulate = Color.BLACK
	create_tween().tween_property(self, 'modulate', Color.WHITE, 1)
