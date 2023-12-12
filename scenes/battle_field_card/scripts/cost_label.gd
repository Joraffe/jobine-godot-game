extends Label


func update_label_styling(cost_text : String, color: Color):
	text = cost_text
	add_theme_color_override("font_color", color)
