extends Node2D


var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)



#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set(
		"image_data",
		self.get_image_data_for_background_name(battle_data.background_name)
	)


#=======================
# Helpers
#=======================
func get_image_data_for_background_name(background_name : String) -> ImageData:
	return ImageData.new(
		"battle_background",
		background_name,
		"{name}.png".format({"name": background_name})
	)
