extends Resource
class_name BattleFieldHandData


var hand : Array[Card]

const MAX_HAND_SIZE : int = 5


func _init(cards : Array[Dictionary]) -> void:
	hand = Card.create_multi(cards)

func get_current_hand() -> Array[Card]:
	return hand

func get_current_hand_size() -> int:
	return hand.size()

func get_current_hand_as_dicts() -> Array[Dictionary]:
	var hand_as_dicts : Array[Dictionary] = []

	for card in hand:
		hand_as_dicts.append(card.as_dict())
	
	return hand_as_dicts

func is_hand_full() -> bool:
	return get_current_hand().size() >= 5
