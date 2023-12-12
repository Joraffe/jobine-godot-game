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
		if child.get("card") is Card:
			child.queue_free()

func get_num_rendered_cards() -> int:
	var num_rendered : int = 0

	for child in self.get_children():
		if child.get("card") is Card:
			num_rendered += 1

	return num_rendered

func render_hand() -> void:
	var num_already_rendered : int = get_num_rendered_cards()
	var hand : Array[Card] = battle_field_hand.hand
	var hand_data : Dictionary = {
		"available_energy" : battle_field_hand.available_energy,
		"lead_character": battle_field_hand.lead_character,
		"is_player_turn" : battle_field_hand.is_player_turn 
	}
	for i in range(num_already_rendered, battle_field_hand.get_current_hand_size()):
		var card = hand[i]
		var card_instance = instantiate_card(card, hand_data)
		move_drawn_card_from_deck_to_hand(i, card_instance)

func instantiate_card(card : Card, hand_data : Dictionary) -> Node2D:
	var instance = battle_field_card_scene.instantiate()
	instance.set("card", card)
	instance.set("available_energy", hand_data["available_energy"])
	instance.set("lead_character", hand_data["lead_character"])
	instance.set("is_player_turn", hand_data["is_player_turn"])
	add_child(instance)
	return instance

func move_drawn_card_from_deck_to_hand(index, card_instance) -> void:
	var deck_position = Vector2(725, 40)
	var card_hand_position = get_card_position_in_hand(index, card_instance)
	var card_area_2d = card_instance.get_node("Area2D")
	card_area_2d.position = deck_position
	var card_tween = card_instance.create_tween()
	card_tween.tween_property(
		card_area_2d,
		"position",
		card_hand_position,
		0.5
	)
	card_tween.tween_callback(card_area_2d.set_sprite_original_global_position)

func get_card_position_in_hand(index, card_instance) -> Vector2:
	var card_image_data = card_instance.card_image_data

	var card_width = card_image_data.get_img_width()
	var hand_card_margin_x = card_width / 20

	# since empty hand image is centered in the middle of image
	var center_slot_index = 2  

	# math to figure out the relative width of the left-most hand slot
	var starting_x = ((center_slot_index * -1) * (card_width + hand_card_margin_x))
	# Total width taken up by the card width + margin between cards
	var offset_x = card_width + hand_card_margin_x

	var card_area_2d = card_instance.get_node("Area2D")
	var card_pos = card_area_2d.position
	var new_card_pos = Vector2(
		starting_x + offset_x * index,
		card_pos.y
	)
	return new_card_pos
