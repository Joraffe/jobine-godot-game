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
	BattleRadio.connect("start_battle", _on_start_battle)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_battle_arena_party_data(new_data: BattleArenaPartyData) -> void:
	data = new_data

	$"Area2D".render_party()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	data = battle_data.party_data
