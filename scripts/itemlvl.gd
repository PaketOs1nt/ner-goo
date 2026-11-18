extends Control

var lvl: NGLevel
var _creator
var gp
var on_finish
var _path = null


func _input(event: InputEvent) -> void:
	if _path and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if get_global_rect().has_point(get_global_mouse_position()):
			$LvlBtn/Delete.show()
			
func delete_lvl():
	DirAccess.remove_absolute(_path)
	
func set_params(_lvl: NGLevel, _gp, __creator, _on_finish = null):
	gp = _gp
	_creator = __creator
	lvl = _lvl
	on_finish = _on_finish
	var time_left = _lvl.end_beat * (60.0/_lvl.bpm)
	$LvlBtn/NameLabel.text = _lvl.name
	$LvlBtn/BPMLabel.text = "%.2f BPM" % _lvl.bpm
	$LvlBtn/ColorRect.color = _lvl.color
	$LvlBtn/TimeLabel.text = "%d:%.2d" % [int(time_left/60),  int(time_left) % 60]

func play():
	_creator.lvls_disabled = true
	_creator.hide_ui(func(): gp.play_lvl(lvl, on_finish))
