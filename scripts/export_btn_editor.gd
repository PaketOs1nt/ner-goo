extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
@onready var level_map: Control = $"../../LevelMap"
var main_scene = load("res://scenes/scenemain.tscn")

func _ready() -> void:
	_fix_pivot()
	resized.connect(_fix_pivot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "scale", HOVER_SCALE_TO, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_valid():
		tween_hover.kill()
	tween_hover = create_tween()
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _fix_pivot() -> void:
	pivot_offset = size / 2.0

func _pressed() -> void:
	if not $"../LineEditName".correct:
		$"../LineEditName".attention()
		return
		
	if not $"../LineEditBPM".correct:
		$"../LineEditBPM".attention()
		return
	
	if not level_map.music:
		$"../MusicButton".attention()
	
	Music.play_click()
	disabled = true
	level_map.recalc_beats()
	var info = {
		'name': $"../LineEditName".text,
		'bpm': $"../LineEditBPM".bpm,
		'notes': {},
		'color': $"../ColorPicker".color.to_html(),
		'end_beat': level_map.c_beat + 2,
	}

	for n in level_map.note_objs:
		if n.valid():
			info['notes'][str(n.beat)] = {
				'pos': n.pos,
				'color': n.color.to_html()
			}
	var zp = ZIPPacker.new()
	zp.open('user://lvls/' + info['name'] + '.zip')
	zp.start_file('info.json')
	zp.write_file(JSON.stringify(info).to_utf8_buffer())
	zp.close_file()
	zp.start_file('music.' + level_map.music_ext)
	zp.write_file(level_map.music_bin)
	zp.close_file()
	zp.close()
	var tw = create_tween()
	tw.tween_property($"../..", 'modulate', Color.BLACK, 1)
	await tw.finished
	disabled = false
	get_tree().change_scene_to_packed(main_scene)
	
	
