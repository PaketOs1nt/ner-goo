extends Node2D

func _ready() -> void:
	Music.set_default_music()
	$Menu/Levels.disable()
	$Menu/GamePlay.disable()
	
func _enter_tree() -> void:
	modulate = Color.BLACK
	create_tween().tween_property(self, 'modulate', Color.WHITE, 1)
