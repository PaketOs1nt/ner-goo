extends Control

var active := false
const SETTINGS_FILE := "user://settings.json"
var BASE_SETTINGS := {
	"vsync": true,
	"fps": 0
}
func _ready() -> void:
	BASE_SETTINGS["fps"] = int(DisplayServer.screen_get_refresh_rate())
	if FileAccess.file_exists(SETTINGS_FILE):
		var f = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
		var setts: Dictionary = JSON.parse_string(f.get_as_text())
		f.close()
		if setts.has_all(["fps", "vsync"]):
			load_settings(setts)
		else:
			set_base_settings()
	else:
		set_base_settings()
		
func set_base_settings():
	var f = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	f.store_string(JSON.stringify(BASE_SETTINGS))
	f.close()
	load_settings(BASE_SETTINGS)

func open(callback = null):
	active = true
	var sett_tween = create_tween()
	sett_tween.tween_property(self, "position:y", 0, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	if callback is Callable:
		sett_tween.tween_callback(callback)

func close(callback = null):
	active = false
	var sett_tween = create_tween()
	sett_tween.tween_property(self, "position:y", -1080, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	if callback is Callable:
		sett_tween.tween_callback(callback)
		
func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_released("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

func load_settings(setts):
	$VSyncCheckBox.turn(setts["vsync"])
	$FPSSlider.set_fps(setts["fps"])
	$FPSSlider.value = setts["fps"]

func save():
	var f = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	f.store_string(JSON.stringify({
		"vsync": $VSyncCheckBox.button_pressed,
		"fps": int($FPSSlider.value)
	}))
	f.close()
