extends Node


var deck_data : DeckData = DeckData.new()
var image_data : ImageData = ImageData.new("deck", "pettel", "deck.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)
	BattleRadio.connect("hand_is_full", _on_hand_is_full)

func _ready() -> void:
	pass


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	deck_data.can_draw_cards = true
	deck_data.populate_deck(battle_data.party_data.get_all_party_cards())

func _on_hand_is_full() -> void:
	deck_data.can_draw_cards = false
