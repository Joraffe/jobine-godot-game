extends Node

@export var deck_data : DeckData


# Called when the node enters the scene tree for the first time.
func _ready():
	deck_data.populate_deck([
		CardData.new("basic_attack"),
		CardData.new("basic_defend"),
		CardData.new("basic_redraw")
	])
