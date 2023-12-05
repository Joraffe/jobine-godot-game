extends Area2D


@onready var battle_arena_lead = get_parent()
var character_scene = preload("res://scenes/battle_arena_character/BattleArenaCharacter.tscn")


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$Sprite2D.set_texture(
		battle_arena_lead.image_data.get_img_texture()
	)


#=======================
# Area2D Functionality
#=======================
func empty_lead() -> void:
	for child in self.get_children():
		if child.get("character") is Character:
			child.queue_free()
 
func render_lead() -> void:
	var lead_character = battle_arena_lead.lead_character
	instantiate_character(lead_character)


#=======================
# Data Helpers
#=======================
func instantiate_character(character: Character) -> void:
	var instance = character_scene.instantiate()
	instance.set("character", character)
	add_child(instance)
