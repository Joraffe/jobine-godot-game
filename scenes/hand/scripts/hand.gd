extends Node

@export var hand_data : HandData


var basic_card_scene = preload("res://scenes/basic_cards/scenes/BasicCard.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for card_data in hand_data.current_hand:
		var instance = basic_card_scene.instantiate()
		instance.set("card_data", card_data)
		add_child(instance)
