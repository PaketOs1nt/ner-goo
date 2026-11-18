extends Control


func disable():
	self.hide()
	self.process_mode = Node.PROCESS_MODE_DISABLED

func enable():
	self.show()
	self.process_mode = Node.PROCESS_MODE_INHERIT 

func show_ui(cb = null):
	var tw2 = create_tween()
	enable()
	tw2.tween_property(self, 'position:x', 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	if cb is Callable:
		tw2.tween_callback(cb)
		
func hide_ui(cb = null):
	var tw = create_tween()
	tw.tween_property(self, 'position:x', get_viewport_rect().size.x, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tw.tween_callback(func():
		if cb is Callable:
			cb.call()
		self.disable()
	)
