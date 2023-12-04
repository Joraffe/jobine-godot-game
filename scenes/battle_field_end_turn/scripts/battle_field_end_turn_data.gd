extends Resource
class_name BattleFieldEndTurnData


var enabled : bool


func _init(end_turn_data : Dictionary) -> void:
	enabled = end_turn_data[ENABLED]


const ENABLED : String = "enabled"
