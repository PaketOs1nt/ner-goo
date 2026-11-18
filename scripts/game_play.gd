extends Control

var gp_scene = preload('res://scenes/gameplay.tscn')
const GP_OFFSET := Vector2(78, 78)
var disabled: bool = false
var gp = null

func disable():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func enable():
	show()
	process_mode = Node.PROCESS_MODE_INHERIT 

func del_gp():
	if gp:
		gp.queue_free()
		gp = null
	$AccuracyLabel.off()
	$GPCube/ColorRect.color = Color.WHITE

func hide_ui(cb = null):
	disabled = true
	var tw = create_tween()

	tw.tween_property(self, 'position:y', 1080, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tw.tween_callback(func():
		self.disabled = false
		if self.gp:
			self.del_gp()
		if cb is Callable:
			cb.call()
		self.disable()
		Music.set_default_music()
	)
	
func _unhandled_input(event: InputEvent) -> void:
	if not disabled and event.is_action_released("ui_cancel"):
		hide_ui($"../Levels".show_ui)
	
func show_ui(cb = null):
	$StatsBG.modulate.a = 0
	enable()
	var tw = create_tween()
	tw.tween_property(self, 'position:y', 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tw.tween_callback(func():
		if cb is Callable:
			cb.call()
	)

func play_lvl(lvl: NGLevel, on_finish = null):
	show_ui(func(): _play_lvl(lvl, on_finish))

func _play_lvl(lvl: NGLevel, on_finish = null):
	gp = gp_scene.instantiate()
	gp.position = $GPBG.position + GP_OFFSET+Vector2(2, 2)
	gp.size = $GPBG.size - GP_OFFSET*2
	gp.lvl_notes = lvl.notes.duplicate()
	gp.end_beat = lvl.end_beat
	gp.target_color_rect = $GPCube/ColorRect
	gp.stats = StatisticGP.new()
	$AccuracyLabel.stats = gp.stats
	$AccuracyLabel.enabled = true
	Music.play_music(lvl.music, lvl.bpm, lvl.offset)
	add_child(gp)
	var _stats = gp.stats
	await gp.finish
	del_gp()
	$StatsBG.set_stats(_stats)
	create_tween().tween_property($StatsBG, "modulate:a", 1, 0.1)
	await $StatsBG/CloseBtn.pressed
	
	if on_finish is Callable:
		on_finish.call()
