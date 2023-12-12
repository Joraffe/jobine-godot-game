extends Node2D


var swap_character : Character :
	set = set_swap_character
var swap_position : String :
	set = set_swap_position
var is_player_turn : bool :
	set = set_is_player_turn
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
func set_swap_character(new_character : Character) -> void:
	swap_character = new_character
	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_field_swap_member", # scene
			swap_character.machine_name,  # instance
			"{name}.png".format({"name": swap_character.machine_name})  # filename
		)
	)

func set_swap_position(new_position : String) -> void:
	swap_position = new_position

func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(new_image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_player_turn_started() -> void:
	is_player_turn = true

func _on_player_turn_ended() -> void:
	is_player_turn = false
