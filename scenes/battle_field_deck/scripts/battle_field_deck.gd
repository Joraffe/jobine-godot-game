extends Node2D


var data : BattleFieldDeckData:
	set = set_battle_field_deck_data
var image_data : ImageData = ImageData.new(
	"battle_field_deck",
	"pettel",
	"deck.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.HAND_FILLED, _on_hand_filled)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_battle_field_deck_data(new_data : BattleFieldDeckData) -> void:
	data = new_data


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.deck_data

func _on_hand_filled() -> void:
	data.can_draw_cards = false
