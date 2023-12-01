extends Node2D


var data : BattleFieldSwapMemberData:
	set = set_battle_field_swap_member_data
var image_data : ImageData:
	set = set_image_data


#=======================
# Setters
#=======================
func set_battle_field_swap_member_data(new_data : BattleFieldSwapMemberData) -> void:
	data = new_data
	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_field_swap_member", # scene
			data.character.machine_name,  # instance
			"{name}.png".format({"name": data.character.machine_name})  # filename
		)
	)


func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(new_image_data.get_img_texture())
