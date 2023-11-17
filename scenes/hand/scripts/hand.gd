extends Node

var hand_data : HandData = HandData.new()
var image_data : ImageData = ImageData.new("hand", "empty", "hand.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	BattleRadio.connect("draw_card", _on_draw_card)


func _on_draw_card(card_data : CardData):
	hand_data.add_card_to_hand(card_data)
	$"Area2D".render_hand()
