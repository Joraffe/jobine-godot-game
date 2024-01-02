extends Node2D


var combos_width : int :
	set = set_combos_width
var combos_height : int :
	set = set_combos_height

var combos : Array[String] :
	set = set_combos


#=======================
# Setters
#=======================
func set_combos_width(new_combos_width : int) -> void:
	combos_width = new_combos_width

	$Panel.custom_minimum_size.x = self.combos_width

func set_combos_height(new_combos_height : int) -> void:
	combos_height = new_combos_height

	$Panel.custom_minimum_size.y = self.combos_height

func set_combos(new_combos : Array[String]) -> void:
	combos = new_combos

	$Panel/MarginContainer/Label.set_text(self.get_combo_details(self.combos))


#=======================
# Helpers
#=======================
func get_combo_details(combos_to_detail : Array[String]) -> String:
	var details : String = ""

	details += "Combos:"
	for combo in combos_to_detail:
		details += "\n"
		details += combo.capitalize()

	return details
