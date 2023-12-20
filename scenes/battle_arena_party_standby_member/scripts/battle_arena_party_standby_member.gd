extends Node2D


var standby_character : Character :
	set = set_standby_character
var standby_position : String :
	set = set_standby_position


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass


#=======================
# Setters
#=======================
func set_standby_character(new_standby_character : Character) -> void:
	standby_character = new_standby_character
	$Area2D.set("standby_character", self.standby_character)

func set_standby_position(new_standby_position : String) -> void:
	standby_position = new_standby_position
	$Area2D.set("standby_position", self.standby_position)


#=======================
# Signal Handlers
#=======================


#=======================
# Helpers
#=======================
