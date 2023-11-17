extends Node

# Overall Battle Related
signal start_battle

# Deck Related
signal draw_card(card_data : CardData)


# Called when the node enters the scene tree for the first time.
func _ready():
	start_battle.emit()
