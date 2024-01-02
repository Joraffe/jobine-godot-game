extends Node2D

var is_player_turn : bool :
	set = set_is_player_turn
var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.TURN_ENDED, _on_turn_ended)


#=======================
# Setters
#=======================
func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn

	# Also update the button image + text
	var instance_name : String
	var button_text : String
	var text_size : int
	
	if self.is_player_turn:
		instance_name = "end_turn"
		button_text = "End Turn"
		text_size = 40
	else:
		instance_name = "enemy_turn"
		button_text = "Enemy Turn"
		text_size = 30

	self.set(
		"image_data",
		ImageData.new(
			"battle_field_turn_button", # scene
			instance_name,  # instance
			"{name}.png".format({"name": instance_name})  # filename
		)
	)
	self.update_button(button_text, text_size)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_turn_started(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", true)

func _on_turn_ended(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", false)


#========================
# Child Node Helpers
#========================
func update_button(button_text : String, text_size : int) -> void:
	$Area2D/Sprite2D/Label.update_button_text(button_text)
	$Area2D/Sprite2D/Label.update_button_text_size(text_size)
