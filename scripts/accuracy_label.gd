extends Label

var enabled = false
var stats: StatisticGP

func _process(_delta: float) -> void:
	if enabled:
		text = "%.2f%%" % (stats.accuracy * 100)
		
func off():
	enabled = false
	text = ""
