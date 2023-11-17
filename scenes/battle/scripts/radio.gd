extends Node

 
# Overall Battle Related
signal start_battle

# Deck Related
signal draw_card(card_data : CardData)


# Called when the node enters the scene tree for the first time.
func _ready():
	print('emitting start_battle')
	start_battle.emit()


func get_battle_radio_node():
	return get_node("self")
