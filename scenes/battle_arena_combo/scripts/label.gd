extends Label


func update_combo_text(combo: Combo) -> void:
	text = "{name}".format({"name": combo.human_name})
	if combo.machine_name == Combo.EVAPORATE:
		set_evaporate_text_color()
	elif combo.machine_name == Combo.GROW:
		set_grow_text_color()
	elif combo.machine_name == Combo.BURN:
		set_burn_text_color()

func reset_combo_text() -> void:
	text = ""

func set_evaporate_text_color() -> void:
	add_theme_color_override("font_color", Color.CORAL)

func set_grow_text_color() -> void:
	add_theme_color_override("font_color", Color.WEB_GREEN)

func set_burn_text_color() -> void:
	add_theme_color_override("font_color", Color.CRIMSON)
