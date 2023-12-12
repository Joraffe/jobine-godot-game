extends Node2D


var lead_character : Character :
	set = set_lead_character
var top_swap_character : Character :
	set = set_top_swap_character
var bottom_swap_character : Character :
	set = set_bottom_swap_character
var is_player_turn : bool :
	set = set_is_player_turn
var image_data : ImageData = ImageData.new(
	"battle_field_swap",
	"empty",
	"swap.png"
)

const LEAD_CHARACTER : String = "lead_character"
const TOP_SWAP_CHARACTER : String = "top_swap_character"
const BOTTOM_SWAP_CHARACTER : String = "bottom_swap_character"


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.CHARACTER_SWAPPED, _on_character_swapped)


#=======================
# Setters
#=======================
func set_lead_character(new_character : Character) -> void:
	lead_character = new_character

func set_top_swap_character(new_character : Character) -> void:
	top_swap_character = new_character

func set_bottom_swap_character(new_character : Character) -> void:
	bottom_swap_character = new_character

func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	lead_character = battle_data.lead_character
	top_swap_character = battle_data.top_swap_character
	bottom_swap_character = battle_data.bottom_swap_character
	$Area2D.render_party_swap_members()

func _on_player_turn_started() -> void:
	is_player_turn = true

func _on_player_turn_ended() -> void:
	is_player_turn = false

func _on_character_swapped(character : Character, swap_position : String) -> void:
	if swap_position == TOP_SWAP_CHARACTER:
		top_swap_character = lead_character
	elif swap_position == BOTTOM_SWAP_CHARACTER:
		bottom_swap_character = lead_character
	lead_character = character

	$Area2D.empty_party_swap_members()
	$Area2D.render_party_swap_members()
