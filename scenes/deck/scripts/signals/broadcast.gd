extends Node


signal card_drawn(card : CardData)


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Area2D".connect("deck_clicked", _on_deck_clicked)


func _on_deck_clicked():
	print('deck clicked!')
	var card = $"../".deck_data.draw_card()
	card_drawn.emit(card)
