extends Resource
class_name BattleFieldEssenceData


var consumed_cards : Array[Card]


func _init(essence_data : Dictionary) -> void:
	consumed_cards = Card.create_multi(essence_data[CONSUMED_CARDS])


const CONSUMED_CARDS : String = "consumed_cards"
