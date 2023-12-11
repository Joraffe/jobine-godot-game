extends Area2D


@onready var battle_field_swap = get_parent()
var battle_field_swap_member_scene = preload(
	"res://scenes/battle_field_swap_member/BattleFieldSwapMember.tscn"
)

#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	$Sprite2D.set_texture(
		battle_field_swap.image_data.get_img_texture()
	)


#=======================
# Area2D Functionality
#=======================
func empty_party_swap_members() -> void:
	for child in self.get_children():
		if child.get("swap_character") is Character:
			child.queue_free()

func render_party_swap_members() -> void:
	var top_swap_character = battle_field_swap.top_swap_character
	var top_position = battle_field_swap.TOP_SWAP_CHARACTER
	var top_instance = instantiate_member(top_swap_character, top_position)
	position_swap_member(top_instance, top_position)

	var bottom_swap_character = battle_field_swap.bottom_swap_character
	var bottom_position = battle_field_swap.BOTTOM_SWAP_CHARACTER
	var bottom_instance = instantiate_member(bottom_swap_character, bottom_position)
	position_swap_member(bottom_instance, bottom_position)

func instantiate_member(character : Character, swap_position : String) -> Node2D:
	var instance = battle_field_swap_member_scene.instantiate()
	instance.set("swap_character", character)
	instance.set("swap_position", swap_position)
	add_child(instance)
	return instance

func position_swap_member(instance : Node2D, swap_position : String) -> void:
	var member_area_2d = instance.get_node("Area2D")
	var member_swap_icon = instance.get_node("SwapSprite2D")
	var pos_y : int
	if swap_position == battle_field_swap.TOP_SWAP_CHARACTER:
		pos_y = 100
	elif swap_position == battle_field_swap.BOTTOM_SWAP_CHARACTER:
		pos_y = -100
	member_area_2d.position = Vector2(-75, pos_y)
	member_area_2d.set_sprite_original_global_position()
	member_swap_icon.position = Vector2(100, pos_y)
