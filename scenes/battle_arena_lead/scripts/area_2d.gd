extends Area2D


@onready var battle_arena_lead = get_parent()


var character_scene = preload("res://scenes/battle_arena_character/BattleArenaCharacter.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_texture(
		battle_arena_lead.image_data.get_img_texture()
	)

func empty_lead() -> void:
	for child in self.get_children():
		if child.get("data") is BattleArenaCharacterData:
			child.queue_free()
 
func render_lead() -> void:
	var lead_data = battle_arena_lead.data
	var character_data = lead_data.character.as_dict()
	instantiate_character(character_data)

func instantiate_character(character_data: Dictionary) -> void:
	var instance = character_scene.instantiate()
	instance.set(
		"data",
		BattleArenaCharacterData.new(character_data)
	)
	add_child(instance)
