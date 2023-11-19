extends Resource
class_name BattleFieldEssenceData


var consumed_cards : Array[BattleFieldCardData]


func _init(_consumed_cards : Array[BattleFieldCardData]) -> void:
	consumed_cards = _consumed_cards
