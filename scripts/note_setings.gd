extends Control

var anim_to_X: float
var anim_from_X: float
var tween_anim: Tween
@onready var level_map: Control = $".."
@onready var color_picker_button: ColorPickerButton = $ColorPickerButton
var selected = null

func _ready() -> void:
	anim_from_X = position.x
	anim_to_X = position.x-256
	level_map.select_note.connect(_note_selected)
	level_map.deselect_note.connect(_note_deselected)
	color_picker_button.color_changed.connect(_color_changed)
	color_picker_button.popup_closed.connect(_on_color_finalized)

func _on_color_finalized():
	level_map.select_note.emit(selected)

func _color_changed(col: Color):
	selected.set_color(col)

func _note_deselected(n) -> void:
	if selected and selected.beat == n.beat:
		selected = null
		__hide()
		
func __hide():
	if tween_anim and tween_anim.is_valid():
		tween_anim.kill()
	tween_anim = create_tween()
	tween_anim.tween_property(self, 'position:x', anim_from_X, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)

func __show():
	if tween_anim and tween_anim.is_valid():
		tween_anim.kill()
	tween_anim = create_tween()
	tween_anim.tween_property(self, 'position:x', anim_to_X, 0.3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)


func _note_selected(n) -> void:
	selected = n
	color_picker_button.color = n.color
	__show()
