extends Node2D


var character_data : CharacterData:
	set = set_character_data
var character_image_data : ImageData:
	set = set_character_image_data


func set_character_data(new_character_data : CharacterData):
	character_data = new_character_data
	# Also set the character_image_data
	self.set(
		"character_image_data",
		ImageData.new(
			"character", # scene
			character_data.name,  # instance
			"{name}.png".format({"name": character_data.name})  # filename
		)
	)


func set_character_image_data(new_image_data : ImageData):
	character_image_data = new_image_data
	# Also update the Sprite2D with this new image
	$"Area2D/Sprite2D".set_texture(character_image_data.get_img_texture())
