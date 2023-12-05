extends Node


var hand : Array[Card]:
	set = set_hand
var max_hand_size : int:
	set = set_max_hand_size
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
func set_hand(new_hand : Array[Card]) -> void:
	hand = new_hand

	$Area2D.render_hand()

func set_max_hand_size(new_max_hand_size : int) -> void:
	max_hand_size = new_max_hand_size

func set_available_energy(new_available_energy : int) -> void:
	available_energy = new_available_energy


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	hand = battle_data.hand
	max_hand_size = battle_data.max_hand_size

func _on_card_drawn(drawn_card : Card) -> void:
	var new_hand : Array[Card] = []
	var cur_hand : Array[Card] = self.get_current_hand()

	for card_in_hand in cur_hand:
		new_hand.append(card_in_hand)
	new_hand.append(drawn_card)

	hand = new_hand

	if self.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_cards_drawn(drawn_cards : Array[Card]) -> void:
	var new_hand : Array[Card] = []
	var cur_hand : Array[Card] = self.get_current_hand()

	for card_in_hand in cur_hand:
		new_hand.append(card_in_hand)
	for drawn_card in drawn_cards:
		new_hand.append(drawn_card)

	hand = new_hand

	if self.is_hand_full():
		BattleRadio.emit_signal(BattleRadio.HAND_FILLED)

func _on_current_energy_updated(current_energy : int) -> void:
	available_energy = current_energy


#=======================
# Data Helpers
#=======================
func get_current_hand() -> Array[Card]:
	return self.hand

func get_current_hand_size() -> int:
	return self.hand.size()

func get_current_hand_as_dicts() -> Array[Dictionary]:
	var hand_as_dicts : Array[Dictionary] = []

	for card in self.hand:
		hand_as_dicts.append(card.as_dict())
	
	return hand_as_dicts

func is_hand_full() -> bool:
	return self.hand.size() >= 5
