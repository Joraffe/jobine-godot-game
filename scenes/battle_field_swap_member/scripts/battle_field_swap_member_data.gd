extends Resource
class_name BattleFieldSwapMemberData


var character : Character
var swap_position : String


func _init(
	character_data : Dictionary,
	position_name : String
) -> void:
	character = Character.create(character_data)
	swap_position = position_name
