extends Resource
class_name HandData


var current_hand : Array[CardData] = []


func add_card_to_hand(card_data : CardData):
	current_hand.append(card_data)


func get_current_hand():
	return current_hand
