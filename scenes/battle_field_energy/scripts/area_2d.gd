extends Area2D


@onready var battle_field_energy : Node2D = get_parent()


#=======================
# Area2D Functionality
#=======================
func update_energy_label(current_energy : int, max_energy : int) -> void:
	$Sprite2D/Label.text = "{current} / {max} ".format({
		"current": current_energy,
		"max": max_energy
	})
