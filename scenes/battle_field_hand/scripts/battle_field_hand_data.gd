extends Resource
class_name BattleFieldHandData


var hand : Array[Card]
var available_energy : int


func _init(cards : Array[Dictionary], energy_data : Dictionary) -> void:
	hand = Card.create_multi(cards)
	available_energy = energy_data[AVAILABLE_ENERGY]

func get_current_hand() -> Array[Card]:
	return hand

func get_current_hand_as_dicts() -> Array[Dictionary]:
	var hand_as_dicts : Array[Dictionary] = []

	for card in hand:
		hand_as_dicts.append(card.as_dict())
	
	return hand_as_dicts

func is_hand_full() -> bool:
	return get_current_hand().size() >= 5


const AVAILABLE_ENERGY : String = "available_energy"
