extends Area2D


@onready var battle_arena_party = get_parent()


var character_scene = preload("res://scenes/battle_arena_character/BattleArenaCharacter.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_texture(battle_arena_party.image_data.get_img_texture())


func render_party() -> void:
	var party_data = battle_arena_party.data
	for i in party_data.party_members.size():
		var character_data = party_data.party_members[i]
		var character_instance = instantiate_character(character_data)
		position_character_in_party(i, character_instance)


func instantiate_character(character_data: BattleArenaCharacterData) -> Node2D:
	var instance = character_scene.instantiate()
	instance.set("data", character_data)
	add_child(instance)
	return instance


func position_character_in_party(index, character_instance) -> void:
	var character_image_data = character_instance.character_image_data

	var character_width = character_image_data.get_img_width()
	var character_height = character_image_data.get_img_height()

	var offset_x
	var offset_y
	var offset_x_direction_multiplier
	var offset_y_direction_multiplier
	if index == 0:
		offset_x_direction_multiplier = -1
		offset_y_direction_multiplier = -1
	elif index == 1:
		offset_x_direction_multiplier = 1
		offset_y_direction_multiplier = 0
	elif index == 2:
		offset_x_direction_multiplier = -1
		offset_y_direction_multiplier = 1
	offset_x = (((character_width / 2) * 1.5) * offset_x_direction_multiplier)
	offset_y = (((character_height / 2) * 1.5) * offset_y_direction_multiplier)
	
	var starting_x = self.position.x
	var starting_y = self.position.y
	
	var character_area_2d = character_instance.get_node("Area2D")
	var new_character_pos = Vector2(
		starting_x + offset_x,
		starting_y + offset_y
	)
	character_area_2d.position = new_character_pos
