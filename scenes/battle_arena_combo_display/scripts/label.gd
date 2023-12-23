extends Label


func update_combo_text(combo: Combo) -> void:
	text = "{name}".format({"name": combo.human_name})
	self.set_combo_text_color(combo)

func reset_combo_text() -> void:
	text = ""

func set_combo_text_color(combo : Combo) -> void:
	if combo.is_evaporate():
		self.set_evaporate_text_color()
	elif combo.is_burn():
		self.set_burn_text_color()
	elif combo.is_explode():
		self.set_explode_text_color()
	elif combo.is_grow():
		self.set_grow_text_color()
	elif combo.is_charge():
		self.set_charge_text_color()
	elif combo.is_chill():
		self.set_chill_text_color()
	elif combo.is_melt():
		self.set_melt_text_color()
	elif combo.is_blaze():
		self.set_blaze_text_color()
	elif combo.is_grow():
		self.set_burn_text_color()
	elif combo.is_freeze():
		self.set_freeze_text_color()
	elif combo.is_surge():
		self.set_surge_text_color()
	elif combo.is_tempest():
		self.set_tempest_text_color()
	elif combo.is_torrent():
		self.set_torrent_text_color()
	else:
		return

func set_evaporate_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CORAL)

func set_burn_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CRIMSON)

func set_explode_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CORAL)

func set_charge_text_color() -> void:
	self.add_theme_color_override("font_color", Color.YELLOW)

func set_chill_text_color() -> void:
	self.add_theme_color_override("font_color", Color.LIGHT_BLUE)

func set_melt_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CORAL)

func set_blaze_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CRIMSON)

func set_grow_text_color() -> void:
	self.add_theme_color_override("font_color", Color.WEB_GREEN)

func set_freeze_text_color() -> void:
	self.add_theme_color_override("font_color", Color.LIGHT_BLUE)

func set_surge_text_color() -> void:
	self.add_theme_color_override("font_color", Color.YELLOW)

func set_tempest_text_color() -> void:
	self.add_theme_color_override("font_color", Color.YELLOW)

func set_torrent_text_color() -> void:
	self.add_theme_color_override("font_color", Color.CORNFLOWER_BLUE)
