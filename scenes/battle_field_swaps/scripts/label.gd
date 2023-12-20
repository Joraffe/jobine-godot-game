extends Label


func update_num_available_swaps(num_available_swaps : int) -> void:
	text = "{num}".format({"num" : num_available_swaps})
