extends Label


#=======================
# Label Functionality
#=======================
func update_discard_pile_number(num_cards : int) -> void:
	if num_cards < 10:
		# Adds a space prefix to help w/ centering
		text = " {num}".format({"num": num_cards})
	else:
		text = "{num}".format({"num": num_cards})
