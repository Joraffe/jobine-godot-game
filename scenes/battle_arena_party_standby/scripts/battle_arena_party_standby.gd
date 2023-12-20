extends Node2D


var standby_top_character : Character :
	set = set_standby_top_character
var standby_bottom_character : Character :
	set = set_standby_bottom_character


#=======================
# Setters
#=======================
func set_standby_top_character(new_character : Character) -> void:
	standby_top_character = new_character
	$TopStandbyMember.set("standby_character", self.standby_top_character)

func set_standby_bottom_character(new_character : Character) -> void:
	standby_bottom_character = new_character
	$BottomStandbyMember.set("standby_character", self.standby_bottom_character)


#=======================
# Helpers
#=======================
