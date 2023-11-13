extends Node


@export var card_data : CardData:
	set = set_card_data


func set_card_data(new_card_data: CardData):
	card_data = new_card_data
	# Also update the Sprite2D
	var texture = load(card_data.get_card_image_path())
	$"Area2D/Sprite2D".set_texture(texture)
