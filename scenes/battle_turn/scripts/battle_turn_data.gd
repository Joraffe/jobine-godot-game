extends Resource
class_name BattleTurnData


var is_player_turn : bool


func _init(battle_turn_data : Dictionary) -> void:
	is_player_turn = battle_turn_data[IS_PLAYER_TURN]


const IS_PLAYER_TURN : String = "is_player_turn"
