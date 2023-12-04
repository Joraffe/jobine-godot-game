extends Resource
class_name BattleFieldDiscardData


var discard_pile : Array[Card]


func _init(discard_data : Dictionary) -> void:
	discard_pile = Card.create_multi(discard_data[DISCARD_PILE])


const DISCARD_PILE : String = "discard_pile"
