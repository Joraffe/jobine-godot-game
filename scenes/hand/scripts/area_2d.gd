extends Node2D


@onready var hand = get_parent()


var card_scene = preload("res://scenes/card/scenes/Card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(hand.image_data.get_img_texture())


func empty_hand():
	var children = get_children()
	for child in children:
		child.queue_free()


func render_hand():
	var hand_data = hand.hand_data
	for i in hand_data.current_hand.size():
		var card_data = hand_data.current_hand[i]
		var card_instance = instantiate_card(card_data)
		position_card_in_hand(i, card_instance)


func instantiate_card(card_data : CardData):
	var instance = card_scene.instantiate()
	instance.set("card_data", card_data)
	add_child(instance)
	return instance


func position_card_in_hand(index, card_instance):
	var card_image_data = card_instance.card_image_data

	var card_width = card_image_data.get_img_width()
	var card_height = card_image_data.get_img_height()
	var hand_card_margin_x = card_width / 20
	var hand_card_margin_y = card_height / 10

	# since empty hand image is centered in the middle of image
	var center_slot_index = 2  
	
	# math to figure out the relative width of the left-most hand slot
	var starting_x = ((center_slot_index * -1) * (card_width + hand_card_margin_x))
	# there's a bit of empty margin at the top to allow for slide-up-animation
	var starting_y = hand_card_margin_y
	# Total width taken up by the card width + margin between cards
	var offset_x = card_width + hand_card_margin_x

	var card_area_2d = card_instance.get_node("Area2D")
	var card_pos = card_area_2d.position
	var new_card_pos = Vector2(
		starting_x + offset_x * index,
		starting_y + card_pos.y
	)
	card_area_2d.position = new_card_pos
