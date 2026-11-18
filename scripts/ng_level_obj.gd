class_name NGLevel
extends Object

var bpm := 0.0
var music: AudioStream
var notes: Dictionary[int, NoteData] = {}
var end_beat := 0
var name := "Name"
var color: Color = Color()
var offset := 0.0
var music_ext
var music_bin

func _init(l_bpm: float, l_music: AudioStream, l_notes: Dictionary[int, NoteData], l_end_beat: int, l_name: String, l_color: Color, _offset: float, _music_ext: String = '', _music_bin: PackedByteArray = []) -> void:
	bpm = l_bpm
	music = l_music
	notes = l_notes
	end_beat = l_end_beat
	name = l_name
	color = l_color
	offset = _offset
	music_ext = _music_ext
	music_bin = _music_bin

static func get_test():
	return NGLevel.new(Music.BPM, Music.player.stream, {
		2: NoteData.new(0, Color.AQUA),
		4: NoteData.new(1, Color.BISQUE),
		6: NoteData.new(3, Color.BLUE),
		7: NoteData.new(4, Color.BLUE_VIOLET),
		8: NoteData.new(5, Color.GREEN),
		10: NoteData.new(2, Color.YELLOW),
		12: NoteData.new(8, Color.DARK_SLATE_GRAY),
		14: NoteData.new(7, Color.RED),
		20: NoteData.new(6, Color.HOT_PINK),
		22: NoteData.new(0, Color.SLATE_GRAY),
		23: NoteData.new(8, Color.BLACK),
		24: NoteData.new(6, Color.WHITE),
		25: NoteData.new(0, Color.YELLOW_GREEN),
		26: NoteData.new(2, Color.ORANGE)
	}, 28, "Test", Color(randf(), randf(), randf()), 0.0)

static func from_file(path: String):
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		return get_test()
		
	var files = reader.get_files()
	if 'info.json' not in files:
		return get_test()
	files.erase('info.json')
	if len(files) != 1:
		return get_test()
	if not files[0].begins_with('music'):
		return get_test()
	var mfile: String = files[0]
	var data = reader.read_file('info.json')
	var text = data.get_string_from_utf8()
	var info: Dictionary = JSON.parse_string(text)
	var ext = mfile.get_extension().to_lower()
	var bin = reader.read_file(mfile)
	var audio = Music.load_audio_from_buffer(bin, ext)
	reader.close()
	var l_notes: Dictionary[int, NoteData] = {}
	for beat in info['notes']:
		l_notes[int(beat)] = NoteData.from_json(info['notes'][beat])
	return NGLevel.new(
		info['bpm'],
		audio,
		l_notes,
		info['end_beat'],
		info['name'],
		Color.from_string(info['color'], Color.BLACK),
		info.get("offset", 0.0), ext, bin
	)
	
