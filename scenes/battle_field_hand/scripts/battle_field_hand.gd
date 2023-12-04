extends Node


var data : BattleFieldHandData:
	set = set_hand_data

var available_energy : int:
	set = set_available_energy

var image_data : ImageData = ImageData.new(
	"battle_field_hand",
	"empty",
	"hand.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CARD_DRAWN, _on_card_drawn)
	BattleRadio.connect(BattleRadio.CURRENT_ENERGY_UPDATED, _on_current_energy_updated)
	BattleRadio.connect(BattleRadio.CARDS_DRAWN, _on_cards_drawn)


#=======================
# Setters
#=======================
func set_hand_data(new_data : BattleFieldHandData) -> void:
	data = new_data

	$Area2D.render_hand()

func set_available_energy(new_available_energy : int) -> void:
	available_energy = new_available_energy


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.hand_data

func _on_card_drawn(card : Card) -> void:
	var hand_as_dicts : Array[Dictionary] = data.get_current_hand_as_dicts()
	hand_as_dicts.append(card.as_dict())
	data = BattleFieldHandData.new(hand_as_dicts)
	if data.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_cards_drawn(cards : Array[Card]) -> void:
	var cards_as_dicts : Array[Dictionary] = data.get_current_hand_as_dicts()
	for card in cards:
		cards_as_dicts.append(card.as_dict())
	data = BattleFieldHandData.new(cards_as_dicts)
	if data.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_current_energy_updated(current_energy : int) -> void:
	available_energy = current_energy
