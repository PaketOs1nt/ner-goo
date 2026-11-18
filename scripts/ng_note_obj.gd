class_name NoteData
extends Object

var pos: int
var color: Color

func _init(n_pos: int, n_color: Color) -> void:
	pos = n_pos
	color = n_color

static func from_json(j: Dictionary):
	return NoteData.new(j['pos'], Color.from_string(j['color'], Color.BLACK))

func to_json():
	return {
		'pos': pos,
		'color': color.to_html()
	}
