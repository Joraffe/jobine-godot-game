extends Label


func update_button_text(new_text : String) -> void:
	text = "{button_text}".format({"button_text" : new_text})

func update_button_text_size(text_size : int) -> void:
	add_theme_font_size_override("font_size", text_size)
