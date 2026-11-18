extends Control

@onready var lvl_container: VBoxContainer = $LvlScroller/LvlsContainer
@onready var song_item_scene = preload("res://scenes/itemlvl.tscn")
var user_lvls_path = 'user://lvls'
var loaded_files: Dictionary = {}
var disabled := false
var lvls_disabled := false
func disable():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func enable():
	show()
	process_mode = Node.PROCESS_MODE_INHERIT 


func loadlvls():
	if not DirAccess.dir_exists_absolute(user_lvls_path):
		DirAccess.make_dir_absolute(user_lvls_path)
	if lvl_container.get_child_count() == 0:
		var item = song_item_scene.instantiate()
		item.set_params(NGLevel.get_test(), $"../GamePlay", self, func(): $"../GamePlay".hide_ui(show_ui))
		lvl_container.add_child(item)
	else:
		var files = DirAccess.get_files_at(user_lvls_path)
		if len(files) != lvl_container.get_child_count()-1:
			for file in files:
				if file not in loaded_files:
					var path = user_lvls_path + '/' + file
					var item = song_item_scene.instantiate()
					item.set_params(NGLevel.from_file(path), $"../GamePlay", self, func(): $"../GamePlay".hide_ui(show_ui))
					lvl_container.add_child(item)
					item._path = path
					loaded_files[file] = item
					
			var to_remove = []
			for lf in loaded_files:
				if lf not in files:
					to_remove.append(lf)
			for to_r in to_remove:
				loaded_files[to_r].queue_free()
				loaded_files.erase(to_r)

func _on_levels_timeout() -> void:
	loadlvls()
	
func _unhandled_input(event: InputEvent) -> void:
	if not disabled and event.is_action_released("ui_cancel"):
		hide_ui($"../StartMenu".show_ui)

func hide_ui(cb = null):
	disabled = true
	var tw = create_tween()
	tw.tween_property(self, 'position:x', -1920, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tw.tween_callback(func():
		disabled = false
		lvls_disabled = false
		if cb is Callable:
			cb.call()
		self.disable()
	)
	
func show_ui(cb = null):
	enable()
	var tw = create_tween()
	tw.tween_property(self, 'position:x', 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tw.tween_callback(func():
		if cb is Callable:
			cb.call()
	)
