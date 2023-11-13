extends Resource
class_name HandData

@export var current_hand : Array[CardData]


func add_card_to_hand(card_data: CardData):
	current_hand.append(card_data)
