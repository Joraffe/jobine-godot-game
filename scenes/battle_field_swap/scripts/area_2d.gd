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
		if child.get("data") is BattleFieldSwapMemberData:
			child.queue_free()

func render_party_swap_members() -> void:
	var swap_data = battle_field_swap.data

	var top_position = BattleFieldSwapData.TOP
	var top_member_data = swap_data.top_swap_character.as_dict()
	var top_instance = instantiate_member(top_member_data, top_position)
	position_swap_member(top_instance, top_position)
	
	var bottom_position = BattleFieldSwapData.BOTTOM
	var bottom_member_data = swap_data.bottom_swap_character.as_dict()
	var bottom_instance = instantiate_member(bottom_member_data, bottom_position)
	position_swap_member(bottom_instance, bottom_position)

func instantiate_member(character_data : Dictionary, swap_position : String) -> Node2D:
	var instance = battle_field_swap_member_scene.instantiate()
	instance.set(
		"data",
		BattleFieldSwapMemberData.new(
			character_data,
			swap_position
		)
	)
	add_child(instance)
	return instance

func position_swap_member(instance : Node2D, swap_position : String) -> void:
	var member_area_2d = instance.get_node("Area2D")
	var member_swap_icon = instance.get_node("SwapSprite2D")
	var pos_y : int
	if swap_position == BattleFieldSwapData.TOP:
		pos_y = 100
	elif swap_position == BattleFieldSwapData.BOTTOM:
		pos_y = -100
	member_area_2d.position = Vector2(-75, pos_y)
	member_swap_icon.position = Vector2(100, pos_y)
