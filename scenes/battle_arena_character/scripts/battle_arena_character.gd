extends Node2D


var character : Character:
	set = set_character

var image_data : ImageData:
	set = set_image_data


#=======================
# Setters
#=======================
func set_character(new_character : Character) -> void:
	character = new_character

	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_character", # scene
			character.machine_name,  # instance
			"{name}.png".format({"name": character.machine_name})  # filename
		)
	)

func set_image_data(new_image_data : ImageData):
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())
	# Also update the Health Bar
	$HealthBar.set("entity", character)
	$Aura.set("aura_width", image_data.get_img_width())
	$Aura.set("entity", character)
	$Combo.set("entity", character)
