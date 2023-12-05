extends Node2D

var enabled : bool:
	set = set_enabled
var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)


#=======================
# Setters
#=======================
func set_enabled(new_status : bool) -> void:
	enabled = new_status

	# Also set the ImageData
	var instance_name
	if enabled:
		instance_name = "enabled"
	else:
		instance_name = "disabled"
	self.set(
		"image_data",
		ImageData.new(
			"battle_field_end_turn", # scene
			instance_name,  # instance
			"{name}.png".format({"name": instance_name})  # filename
		)
	)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_player_turn_started() -> void:
	enabled = true

func _on_player_turn_ended() -> void:
	enabled = false
