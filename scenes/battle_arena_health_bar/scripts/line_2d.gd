extends Line2D


func fill_health_bar(max_hp : int, current_hp : int, hp_bar_width: int) -> void:
	var max_hp_float = float(max_hp)
	var current_hp_float = float(current_hp)
	var hp_bar_width_float = float(hp_bar_width)

	var percentage : float = current_hp_float / max_hp_float
	var filled_hp_float : float = hp_bar_width_float * percentage

	var filled_hp_bar_x : int = int(filled_hp_float)

	var start_hp_bar_x : int = (-1 * int(hp_bar_width / 2.0)) + 3

	self.points = PackedVector2Array([
		Vector2(start_hp_bar_x, 0),
		Vector2(start_hp_bar_x + filled_hp_bar_x - 6, 0)
	])
