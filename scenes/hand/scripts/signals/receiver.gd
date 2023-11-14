extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Broadcast".connect("add_card_to_hand", _on_add_card_to_hand)
	

func _on_add_card_to_hand(card : CardData):
	$"../".hand_data.add_card_to_hand(card)
	$"../Broadcast".emit_signal("render_hand")
