extends Resource
class_name BattleFieldSwapMemberData


var character_data : BattleArenaCharacterData
var position : String



func _init(
	_character_data : BattleArenaCharacterData,
	_position : String
) -> void:
	character_data = _character_data
	position = _position
