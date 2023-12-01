extends Node2D


var data : BattleArenaLeadData:
	set = set_battle_arena_lead_data
var image_data : ImageData = ImageData.new(
	"battle_arena_lead",
	"empty",
	"lead.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("battle_started", _on_battle_started)
	BattleRadio.connect("character_swapped", _on_character_swapped)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_battle_arena_lead_data(new_data: BattleArenaLeadData) -> void:
	data = new_data
	$"Area2D".render_lead()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.lead_data

func _on_character_swapped(character : Character, _swap_position : String) -> void:
	data.character = character
	$"Area2D".empty_lead()
	$"Area2D".render_lead()
