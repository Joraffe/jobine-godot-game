extends Label


func set_skip_text(status_effect_name : String) -> void:
	if status_effect_name == StatusEffect.FROZEN:
		self.text = "Frozen"

func reset_text() -> void:
	self.text = ""
