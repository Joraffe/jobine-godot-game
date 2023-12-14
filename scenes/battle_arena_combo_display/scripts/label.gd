extends Label


func update_combo_text(combo: Combo) -> void:
	text = "{name}".format({"name": combo.human_name})
	set_combo_text_color(combo)

func reset_combo_text() -> void:
	text = ""

func set_combo_text_color(combo : Combo) -> void:
	if combo.is_evaporate():
		set_evaporate_text_color()
	elif combo.is_burn():
		set_burn_text_color()
	elif combo.is_grow():
		set_grow_text_color()
	elif combo.is_charge():
		set_charge_text_color()
	elif combo.is_chill():
		set_chill_text_color()
	elif combo.is_melt():
		set_melt_text_color()
	elif combo.is_blaze():
		set_blaze_text_color()
	elif combo.is_grow():
		set_burn_text_color()
	elif combo.is_freeze():
		set_freeze_text_color()
	elif combo.is_surge():
		set_surge_text_color()
	elif combo.is_tempest():
		set_tempest_text_color()
	else:
		return

func set_evaporate_text_color() -> void:
	add_theme_color_override("font_color", Color.CORAL)

func set_burn_text_color() -> void:
	add_theme_color_override("font_color", Color.CRIMSON)

func set_charge_text_color() -> void:
	add_theme_color_override("font_color", Color.YELLOW)

func set_chill_text_color() -> void:
	add_theme_color_override("font_color", Color.LIGHT_BLUE)

func set_melt_text_color() -> void:
	add_theme_color_override("font_color", Color.CORAL)

func set_blaze_text_color() -> void:
	add_theme_color_override("font_color", Color.CRIMSON)

func set_grow_text_color() -> void:
	add_theme_color_override("font_color", Color.WEB_GREEN)

func set_freeze_text_color() -> void:
	add_theme_color_override("font_color", Color.LIGHT_BLUE)

func set_surge_text_color() -> void:
	add_theme_color_override("font_color", Color.YELLOW)

func set_tempest_text_color() -> void:
	add_theme_color_override("font_color", Color.YELLOW)
