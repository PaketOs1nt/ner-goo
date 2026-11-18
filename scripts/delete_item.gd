extends Control

@onready var delete_btn: TextureButton = $DeleteBtn
@onready var keep_btn: TextureButton = $KeepBtn
@onready var save_btn: TextureButton = $SaveBtn
@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	keep_btn.pressed.connect(hide)
	delete_btn.pressed.connect($"../..".delete_lvl)
	save_btn.pressed.connect(file_dialog.popup_file_dialog)
	file_dialog.file_selected.connect(func(path):
		DirAccess.copy_absolute($"../.."._path, path)
		hide()
	)
