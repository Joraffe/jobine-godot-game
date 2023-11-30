extends Node2D


var data : BattleArenaPartyData:
	set = set_battle_arena_party_data
var image_data : ImageData = ImageData.new(
	"battle_arena_party",
	"empty",
	"party.png"
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
func set_battle_arena_party_data(new_data: BattleArenaPartyData) -> void:
	data = new_data
	$"Area2D".render_active_party_member()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.party_data

func _on_character_swapped(swap_member_data : BattleFieldSwapMemberData) -> void:
	data.active_party_member = swap_member_data.character_data
	$"Area2D".empty_active_party_member()
	$"Area2D".render_active_party_member()
