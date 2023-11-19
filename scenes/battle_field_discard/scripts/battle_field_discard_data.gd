extends Resource
class_name BattleFieldDiscardData


var discard_pile : Array[BattleFieldCardData]


func _init(_discard_pile : Array[BattleFieldCardData]) -> void:
	discard_pile = _discard_pile
