class_name StatisticGP
extends Object

var _total_accuracy := 0.0
var accuracy := 0.0
var taps := 0
var misses := 0
var combo := 0
var max_combo := 0
var points := 0.0

func register_hit(acc: float):
	taps += 1
	_total_accuracy += acc
	accuracy = _total_accuracy/taps
	points += 100.0*acc + (2.5*combo)
	combo += 1
	if max_combo < combo:
		max_combo = combo

func register_miss():
	combo = 0
	taps += 1
	misses += 1
	accuracy = _total_accuracy/taps
	points -= 50.0
