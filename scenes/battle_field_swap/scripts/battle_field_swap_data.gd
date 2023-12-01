extends Resource
class_name BattleFieldSwapData


const LEAD : String = "lead"
const TOP : String = "swap_member_top"
const BOTTOM : String = "swap_member_bottom"


var lead_character : Character
var top_swap_character : Character
var bottom_swap_character : Character


func _init(
	lead_character_data : Dictionary,
	top_swap_character_data : Dictionary,
	bottom_swap_character_data : Dictionary
) -> void:
	lead_character = Character.create(lead_character_data)
	top_swap_character = Character.create(top_swap_character_data)
	bottom_swap_character = Character.create(bottom_swap_character_data)
