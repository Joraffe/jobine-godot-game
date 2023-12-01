extends Area2D


@onready var battle_field_hand = get_parent()


var battle_field_card_scene = preload("res://scenes/battle_field_card/BattleFieldCard.tscn")


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$Sprite2D.set_texture(
		battle_field_hand.image_data.get_img_texture()
	)


#=======================
# Area2D Functionality
#=======================
func empty_hand() -> void:
	for child in self.get_children():
		if child.get("data") is BattleFieldCardData:
			child.queue_free()

func render_hand() -> void:
	var hand_data = battle_field_hand.data
	for i in hand_data.hand.size():
		var card_data = hand_data.hand[i].as_dict()
		var card_instance = instantiate_card(card_data)
		position_card_in_hand(i, card_instance)

func instantiate_card(card_data : Dictionary) -> Node2D:
	var instance = battle_field_card_scene.instantiate()
	instance.set(
		"data",
		BattleFieldCardData.new(card_data)
	)
	add_child(instance)
	return instance

func position_card_in_hand(index, card_instance) -> void:
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
	card_area_2d.set_sprite_original_global_position()
