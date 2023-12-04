extends Node


var data : BattleFieldHandData:
	set = set_hand_data
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
	BattleRadio.connect(BattleRadio.ENERGY_GAINED, _on_energy_gained)
	BattleRadio.connect(BattleRadio.CARDS_DRAWN, _on_cards_drawn)


#=======================
# Setters
#=======================
func set_hand_data(new_data : BattleFieldHandData) -> void:
	data = new_data

	$Area2D.render_hand()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.hand_data

func _on_card_drawn(card : Card) -> void:
	var hand_as_dicts : Array[Dictionary] = data.get_current_hand_as_dicts()
	var available_energy = data.available_energy
	hand_as_dicts.append(card.as_dict())
	data = BattleFieldHandData.new(
		hand_as_dicts,
		{BattleFieldHandData.AVAILABLE_ENERGY : available_energy}
	)
	if data.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_cards_drawn(cards : Array[Card]) -> void:
	var cards_as_dicts : Array[Dictionary] = data.get_current_hand_as_dicts()
	var available_energy = data.available_energy
	for card in cards:
		cards_as_dicts.append(card.as_dict())
	data = BattleFieldHandData.new(
		cards_as_dicts,
		{
			BattleFieldHandData.AVAILABLE_ENERGY : available_energy
		}
	)
	if data.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_energy_gained(amount : int) -> void:
	var new_hand_data = BattleFieldHandData.new(
		data.get_current_hand_as_dicts(),
		{BattleFieldHandData.AVAILABLE_ENERGY : amount}
	)
	data = new_hand_data
