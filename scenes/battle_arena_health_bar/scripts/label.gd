extends Label


func update_health_bar_text(max_hp : int, current_hp : int) -> void:
	text = "{current}/{max}".format({
		"current": current_hp,
		"max": max_hp
	})
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
