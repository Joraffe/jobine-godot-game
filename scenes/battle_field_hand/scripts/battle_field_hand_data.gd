extends Resource
class_name BattleFieldHandData


var hand : Array[BattleFieldCardData]


func _init(_hand : Array[BattleFieldCardData]) -> void:
	hand = _hand


func get_current_hand() -> Array[BattleFieldCardData]:
	return hand


func is_hand_full() -> bool:
	return get_current_hand().size() >= 5
