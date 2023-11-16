extends Node2D

@export var card_image_data : ImageData:
	set = set_card_image_data
@export var card_data : CardData:
	set = set_card_data


func set_card_data(new_card_data : CardData):
	card_data = new_card_data
	# Also set the card_image_data
	self.set(
		"card_image_data",
		ImageData.new(
			"card",
			"{name}.png".format({"name": new_card_data.card_name})
		)
	)


func set_card_image_data(new_card_image_data : ImageData):
	card_image_data = new_card_image_data

	# Also update the Sprite2D with this new image
	$"Area2D/Sprite2D".set_texture(card_image_data.get_img_texture())
