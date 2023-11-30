extends Node2D


var data : BattleFieldSwapData:
	set = set_battle_field_swap_data
var image_data : ImageData = ImageData.new(
	"battle_field_swap",
	"empty",
	"swap.png"
)

#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("battle_started", _on_battle_started)
	BattleRadio.connect("character_swapped", _on_character_swapped)


#=======================
# Setters
#=======================
func set_battle_field_swap_data(new_battle_swap_data : BattleFieldSwapData) -> void:
	data = new_battle_swap_data
	$Area2D.render_party_swap_members()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.swap_data

func _on_character_swapped(swap_data : BattleFieldSwapMemberData) -> void:
	var swap_old_position = swap_data.position
	data.members[swap_old_position] = data.members[BattleFieldSwapData.ACTIVE]
	data.members[BattleFieldSwapData.ACTIVE] = swap_data.character_data
	$Area2D.empty_party_swap_members()
	$Area2D.render_party_swap_members()
