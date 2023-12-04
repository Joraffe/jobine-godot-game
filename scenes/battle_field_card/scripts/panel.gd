extends Panel


func update_stylebox(color: Color) -> void:
	var new_stylebox = get_theme_stylebox("panel").duplicate()
	new_stylebox.border_color = color
	add_theme_stylebox_override("panel", new_stylebox)
