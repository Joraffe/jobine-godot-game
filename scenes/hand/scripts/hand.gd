extends Node

@export var hand_data : HandData


var basic_card_scene = preload("res://scenes/basic_cards/scenes/BasicCard.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in hand_data.current_hand.size():
		var card_data = hand_data.current_hand[i]
		var instance = basic_card_scene.instantiate()
		instance.set("card_data", card_data)
		offset_card(i, instance)
		add_child(instance)


func offset_card(index, instance):
	var offset_x = 210 # width of a card
	var area_2d = instance.get_node("Area2D")
	var control = instance.get_node("Control")
	var cur_pos = area_2d.position
	var new_pos = Vector2(offset_x * index, cur_pos.y)
	area_2d.position = new_pos
	control.position = new_pos
