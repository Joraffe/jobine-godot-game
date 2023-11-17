extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init():
	battle_data = BattleData.new(
		PartyData.new(
			[
				CharacterData.new(
					Characters.SCREM_PETTEL,
					ScremPettelCards.get_starter_cards()
				),
				CharacterData.new(
					Characters.EVIL_PETTEL,
					EvilPettelCards.get_starter_cards()
				),
				CharacterData.new(
					Characters.FLAT_PETTEL,
					FlatPettelCards.get_starter_cards()
				)
			]
		),
		HandData.new([])
	)
	BattleRadio.connect("draw_card", _on_draw_card)


func _ready():
	BattleRadio.emit_signal("start_battle", battle_data)


#========================
# Signal Handlers
#========================
func _on_draw_card(card_data : CardData) -> void:
	var hand = battle_data.hand_data.get_current_hand()
	hand.append(card_data)
	battle_data.hand_data = HandData.new(hand)

	if battle_data.is_hand_full():
		BattleRadio.emit_signal("hand_is_full")
