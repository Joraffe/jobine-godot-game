extends Resource
class_name HandData

@export var current_hand : Array[CardData]


func add_card_to_hand(card : CardData):
	current_hand.append(card)


func get_current_hand():
	return current_hand
