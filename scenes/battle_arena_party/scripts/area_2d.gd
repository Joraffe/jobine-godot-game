extends Area2D


@onready var battle_arena_party = get_parent()


var character_scene = preload("res://scenes/battle_arena_character/BattleArenaCharacter.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_texture(battle_arena_party.image_data.get_img_texture())


func empty_active_party_member() -> void:
	for child in self.get_children():
		if child.get("data") is BattleArenaCharacterData:
			child.queue_free()
 
func render_active_party_member() -> void:
	var party_data = battle_arena_party.data
	var character_data = party_data.active_party_member
	instantiate_character(character_data)

func instantiate_character(character_data: BattleArenaCharacterData) -> void:
	var instance = character_scene.instantiate()
	instance.set("data", character_data)
	add_child(instance)
