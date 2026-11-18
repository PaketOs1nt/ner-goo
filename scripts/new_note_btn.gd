extends TextureButton

var tween_hover: Tween
const HOVER_SCALE_TO := Vector2(1.1, 1.1)
@onready var note_scroll_container: HBoxContainer = $"../NoteScroller/NoteScrollContainer"
var note_prev_scene = preload('res://scenes/preview_note.tscn')

@onready var level_map: Control = $".."

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
	if not level_map.music_playing:
		Music.play_click()
		var np = note_prev_scene.instantiate()
		np._main = level_map
		np.scroller = $"../NoteScroller"
		note_scroll_container.add_child(np)	
		np.set_data(level_map.new_beat(), -1, Color.WHITE)
		level_map.note_objs.append(np)
		
