extends Node2D


var discard_pile : Array[Card]:
	set = set_discard_pile

var image_data : ImageData = ImageData.new(
	"battle_field_discard",
	"empty",
	"discard.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)


#=======================
# Setters
#=======================
func set_discard_pile(new_discard_pile : Array[Card]) -> void:
	discard_pile = new_discard_pile


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	discard_pile = battle_data.discard_pile
