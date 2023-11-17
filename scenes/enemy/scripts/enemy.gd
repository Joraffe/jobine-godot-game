extends Node2D


var enemy_data : EnemyData:
	set = set_enemy_data
var enemy_image_data : ImageData:
	set = set_enemy_image_data


#=======================
# Setters
#=======================
func set_enemy_data(new_enemy_data : EnemyData) -> void:
	enemy_data = new_enemy_data

	# Also set the image data
	self.set(
		"enemy_image_data",
		ImageData.new(
			"enemy",  # scene
			enemy_data.name,  # instance
			"{name}.png".format({"name": enemy_data.name})  # filename
		)
	)

func set_enemy_image_data(new_enemy_image_data : ImageData) -> void:
	enemy_image_data = new_enemy_image_data

	# Also update the Sprite2D with this new image data
	$Area2D/Sprite2D.set_texture(enemy_image_data.get_img_texture())
