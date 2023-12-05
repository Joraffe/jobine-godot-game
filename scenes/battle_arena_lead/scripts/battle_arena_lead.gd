extends Node2D


var lead_character : Character:
	set = set_lead_character

var image_data : ImageData = ImageData.new(
	"battle_arena_lead",
	"empty",
	"lead.png"
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
func set_lead_character(new_character : Character) -> void:
	lead_character = new_character
	$Area2D.render_lead()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	lead_character = battle_data.lead_character

func _on_character_swapped(character : Character, _swap_position : String) -> void:
	lead_character = character
	$Area2D.empty_lead()
	$Area2D.render_lead()
