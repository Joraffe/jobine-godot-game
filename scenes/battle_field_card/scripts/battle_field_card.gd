extends Node2D


var data : BattleFieldCardData:
	set = set_battle_field_card_data
var card_image_data : ImageData:
	set = set_card_image_data


#=======================
# Setters
#=======================
func set_battle_field_card_data(new_battle_field_card_data : BattleFieldCardData):
	data = new_battle_field_card_data
	# Also set the card_image_data
	self.set(
		"card_image_data",
		ImageData.new(
			"battle_field_card",  # scene
			data.card.machine_name,  # instance
			"{name}.png".format({"name": data.card.machine_name})  # filename
		)
	)

func set_card_image_data(new_card_image_data : ImageData):
	card_image_data = new_card_image_data

	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(card_image_data.get_img_texture())
