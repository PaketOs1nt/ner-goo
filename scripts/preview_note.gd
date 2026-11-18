extends Control

var pos := -1
var color := Color.BLACK
var beat := -1
var _main
var scroller: ScrollContainer

func _ready() -> void:
	_main.select_note.connect(_select_note)
	_main.deselect_note.connect(_deselect_note)
	$Note.texture = $Note.texture.duplicate()
	$Note.texture.gradient = $Note.texture.gradient.duplicate()
	
func set_data(_beat: int, _pos: int, _color: Color):
	set_beat(_beat)
	set_color(_color)
	set_pos(_pos)

func set_color(_color: Color):
	color = _color
	$Note.texture.gradient.set_color(0, color)

func set_beat(_beat: int):
	beat = _beat
	
func set_pos(_pos: int):
	pos = _pos
	if valid():
		@warning_ignore("integer_division")
		$Note.position = Vector2(
			15 + (pos % 3)*55,
			15 + pos/3*55
		)
		$Note.show()
	else:
		$Note.hide()
	
func valid():
	return pos >= 0 and pos <= 8
	
func _select_note(n):
	if n.beat == beat:
		modulate = Color(Color.WHITE, 0.2)
		
func _deselect_note(n):
	if n.beat == beat:
		modulate = Color.WHITE
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not _main.music_playing:
		var mpos = get_global_mouse_position()
		if event.pressed and scroller.get_global_rect().has_point(mpos) and get_global_rect().has_point(mpos):
			if event.button_index == MOUSE_BUTTON_LEFT:
				Music.play_click()
				_main.select_note.emit(self)
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_RIGHT and _main.selected_note and beat == _main.selected_note.beat:
				Music.play_click()
				if pos == -1:
					_main.deselect_note.emit(self)
					_main.note_objs.erase(self)
					queue_free()
					_main.recalc_beats()
				else:
					set_pos(-1)
					_main.select_note.emit(self)
				get_viewport().set_input_as_handled()
				
