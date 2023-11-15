extends Node2D

@onready var hand = get_parent()
@onready var broadcast = $"../Broadcast"

var basic_card_scene = preload("res://scenes/basic_cards/scenes/BasicCard.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	broadcast.connect("render_hand", _on_render_hand)


func _on_render_hand():
	render_hand()


func empty_hand():
	var children = get_children()
	for child in children:
		child.queue_free()


func render_hand():
	var hand_data = hand.hand_data
	for i in hand_data.current_hand.size():
		var card_data = hand_data.current_hand[i]
		var instance = instantiate_card(card_data)
		render_card(i, instance)



func instantiate_card(card_data : CardData):
	var instance = basic_card_scene.instantiate()
	instance.set("card_data", card_data)
	add_child(instance)
	return instance
	

func render_card(index, card_instance):
	var starting_x = -420
	var starting_y = 30
	var offset_x = 210 # width of a card
	var card_area_2d = card_instance.get_node("Area2D")
	var card_pos = card_area_2d.position
	var new_card_pos = Vector2(
		starting_x + offset_x * index,
		starting_y + card_pos.y
	)
	card_area_2d.position = new_card_pos
