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
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CHARACTER_SWAPPED, _on_character_swapped)


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

func _on_character_swapped(character : Character, swap_position : String) -> void:
	if swap_position == BattleFieldSwapData.TOP:
		data.top_swap_character = data.lead_character
	elif swap_position == BattleFieldSwapData.BOTTOM:
		data.bottom_swap_character = data.lead_character
	data.lead_character = character

	$Area2D.empty_party_swap_members()
	$Area2D.render_party_swap_members()
