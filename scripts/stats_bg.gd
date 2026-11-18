extends TextureRect

func set_stats(stats: StatisticGP):
	$AccuracyLabel.text = "ACCURACY: %.2f%%" % (stats.accuracy * 100)
	$PointsLabel.text = "SCORE: %.2f" % stats.points
	$HitsLabel.text = "HITS: %d" % (stats.taps-stats.misses)
	$MissesLabel.text = "MISSES: %d" % stats.misses
	$MaxComboLabel.text = "MAX COMBO: %d" % stats.max_combo
