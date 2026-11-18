extends LineEdit

var correct = false
var bpm = 0.0

func _ready() -> void:
	text_changed.connect(_text_changed)
	modulate = Color.LIGHT_PINK
	
func _text_changed(txt: String):
	correct = txt.is_valid_float()
	if not correct:
		modulate = Color.LIGHT_PINK
	else:
		modulate = Color.WHITE
		bpm = txt.to_float()
		$"../../LevelMap".music_bpm = bpm
	
func attention(): 
	var tw = create_tween()
	tw.tween_property(self, 'modulate', Color.RED, 0.5)
	tw.tween_callback(
		func():
			create_tween().tween_property(
				self, 'modulate', Color.WHITE, 0.5
			)
	)
