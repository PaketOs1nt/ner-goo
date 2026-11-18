extends LineEdit

var correct = false

func _ready() -> void:
	text_changed.connect(_text_changed)
	modulate = Color.LIGHT_PINK
	
func _text_changed(txt: String):
	correct = not txt.is_empty()
	if not correct:
		modulate = Color.LIGHT_PINK
	else:
		modulate = Color.WHITE
	
func attention(): 
	var tw = create_tween()
	tw.tween_property(self, 'modulate', Color.RED, 0.5)
	tw.tween_callback(
		func():
			create_tween().tween_property(
				self, 'modulate', Color.WHITE, 0.5
			)
	)
