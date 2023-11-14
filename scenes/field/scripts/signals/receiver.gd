extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Deck/Broadcast".connect("card_drawn", _on_card_drawn)


func _on_card_drawn(card: CardData):
	$"../Broadcast".emit_signal("add_card_to_hand", card)
