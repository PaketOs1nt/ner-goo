extends Control

var note_scene = preload("res://scenes/note.tscn")
var notes := []
var notes_anims := []
var lvl_notes: Dictionary[int, NoteData]
var end_beat: int
var target_color_rect: ColorRect
var stats: StatisticGP
signal finish
signal tap(pos: int, mpos: float)

func _ready() -> void:
	for y in range(3):
		for x in range(3):
			var note: ColorRect = note_scene.instantiate()
			var note_anim: ColorRect = ColorRect.new()
			note.pos = len(notes)
			notes.append(note)
			notes_anims.append(note_anim)
			
			note.action = tap
			note.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			note.position = Vector2(x*285, y*285)
			note_anim.position = note.position
			
			note.size = Vector2(285, 285)
			note_anim.size = note.size
			
			note_anim.pivot_offset = note_anim.size/2
			note_anim.color.a = 0
			note_anim.z_index = 1
			note_anim.mouse_filter = Control.MOUSE_FILTER_PASS
			
			add_child(note)
			add_child(note_anim)
			
		
	Music.on_beat.connect(_on_beat)
	Music.player.finished.connect(finish.emit)
	tap.connect(on_tap)

func on_tap(pos: int, m_pos: float):
	var closest_beat = round(m_pos / Music.BEAT_INTERVAL)
	var target_time = closest_beat * Music.BEAT_INTERVAL
	var mdist = abs(target_time - m_pos)

	var hit_window = Music.BEAT_INTERVAL/2
	if mdist > hit_window:
		stats.register_miss()
		return
		
	if not closest_beat in lvl_notes:
		stats.register_miss()
		return
		
	var note = lvl_notes[closest_beat]
	if note.pos != pos:
		stats.register_miss()
		return
	
	if mdist < hit_window / 3.0:
		stats.register_hit(1.0) 
	elif mdist < (hit_window * 2.0) / 3.0:
		stats.register_hit(2.0 / 3.0)
	else:
		stats.register_hit(1.0 / 3.0)
		
	lvl_notes.erase(closest_beat)
	
	notes_anims[pos].scale = Vector2.ONE
	notes_anims[pos].color = note.color
	
	create_tween().tween_property(notes_anims[pos], "color", Color(note.color, 0), Music.BEAT_INTERVAL*0.75)
	create_tween().tween_property(notes_anims[pos], "scale", Vector2(1.3, 1.3), Music.BEAT_INTERVAL*0.75)
	Music.play_hit()
	
func _on_beat():
	var c_beat = Music.last_beat
	if c_beat == end_beat:
		finish.emit()
		
	if (c_beat - 1) in lvl_notes:
		stats.register_miss()
		lvl_notes.erase(c_beat-1)
		
	if (c_beat+1) in lvl_notes:
		var note = lvl_notes[c_beat+1]
		create_tween().tween_property(notes[note.pos], "color", note.color, Music.BEAT_INTERVAL)
		create_tween().tween_property(target_color_rect, "color", note.color, Music.BEAT_INTERVAL/2)
		
	if c_beat in lvl_notes:
		var note = lvl_notes[c_beat]
		notes[note.pos].color = note.color
