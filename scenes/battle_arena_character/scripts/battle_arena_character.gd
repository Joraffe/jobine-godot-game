extends Node2D


var data : BattleArenaCharacterData:
	set = set_battle_arena_character_data
var image_data : ImageData:
	set = set_image_data


#=======================
# Setters
#=======================
func set_battle_arena_character_data(new_battle_arena_character_data : BattleArenaCharacterData):
	data = new_battle_arena_character_data
	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_character", # scene
			data.character.machine_name,  # instance
			"{name}.png".format({"name": data.character.machine_name})  # filename
		)
	)

func set_image_data(new_image_data : ImageData):
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())
