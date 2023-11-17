extends Node2D


var card_data : CardData:
	set = set_card_data
var card_image_data : ImageData:
	set = set_card_image_data


#=======================
# Setters
#=======================
func set_card_data(new_card_data : CardData):
	card_data = new_card_data
	# Also set the card_image_data
	self.set(
		"card_image_data",
		ImageData.new(
			"card",  # scene
			card_data.character,  # instance
			"{name}.png".format({"name": card_data.name})  # filename
		)
	)

func set_card_image_data(new_card_image_data : ImageData):
	card_image_data = new_card_image_data

	# Also update the Sprite2D with this new image
	$"Area2D/Sprite2D".set_texture(card_image_data.get_img_texture())
