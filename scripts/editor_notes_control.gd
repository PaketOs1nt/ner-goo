extends Control

@onready var level_map: Control = $".."
@onready var selected_rect: TextureRect = $SelectedRect
var notes := []
var note_anim: ColorRect
var compiled: Dictionary[int, NoteData] = {}

func _ready() -> void:
	selected_rect.hide()
	Music.on_beat.connect(_on_beat)
	level_map.select_note.connect(render_notes)
	note_anim = ColorRect.new()
	note_anim.size = Vector2(144.66666666666666, 144.66666666666666)
	note_anim.color = Color(0,0,0,0)
	note_anim.pivot_offset = note_anim.size/2
	note_anim.mouse_filter = Control.MOUSE_FILTER_PASS
	note_anim.z_index = 1
	add_child(note_anim)
	var idx = 0
	for y in range(3):
		for x in range(3):
			var note: ColorRect = ColorRect.new()
			note.size = Vector2(144.66666666666666, 144.66666666666666)
			note.position = Vector2(x * 144.66666666666666, y * 144.66666666666666)
			note.color = Color.BLACK
			add_child(note)
			notes.append(note)
			note.gui_input.connect(note_gui_input.bind(idx))
			idx += 1

func _on_beat():
	if level_map.music_playing:
		if compiled.size() == 0:
			return
			
		var c_beat = Music.last_beat
			
		if (c_beat - 1) in compiled:
			compiled.erase(c_beat-1)
			
		if (c_beat+1) in compiled:
			var note = compiled[c_beat+1]
			create_tween().tween_property(notes[note.pos], "color", note.color, Music.BEAT_INTERVAL)
			
		if c_beat in compiled:
			var note = compiled[c_beat]
			notes[note.pos].color = note.color
			note_anim.position = Vector2(note.pos%3*144.667, note.pos/3 *144.667)
			note_anim.color = note.color
			note_anim.scale = Vector2.ONE
			create_tween().tween_property(note_anim, "color", Color(note.color, 0), Music.BEAT_INTERVAL*0.75)
			create_tween().tween_property(note_anim, "scale", Vector2(1.3, 1.3), Music.BEAT_INTERVAL*0.75)
			Music.play_hit()

func note_gui_input(e: InputEvent, idx: int):
	if e.is_action_pressed("tap") and not level_map.music_playing:
		if e is InputEventKey and e.is_echo():
			return
		if notes[idx].get_global_rect().has_point(get_global_mouse_position()):
			if level_map.selected_note:
				Music.play_click()
				get_viewport().set_input_as_handled()
				level_map.selected_note.set_pos(idx)
				render_notes(level_map.selected_note)

func start_playing():
	compiled.clear()
	for n in level_map.note_objs:
		if n.valid():
			compiled[n.beat] = NoteData.new(n.pos, n.color)
	render_notes(level_map.selected_note)
	selected_rect.hide()

func render_notes(n):
	if not n:
		return
	for nnn in notes:
		nnn.color = Color.BLACK
	@warning_ignore("standalone_expression")
	level_map.recalc_beats()
	for nn in level_map.note_objs:
		if nn.valid():
			notes[nn.pos].color = nn.color
		if nn.beat == n.beat:
			break
	if n and n.valid():
		selected_rect.show()
		selected_rect.position = Vector2(n.pos%3*144.667, n.pos/3 *144.667)
	else:
		selected_rect.hide()
