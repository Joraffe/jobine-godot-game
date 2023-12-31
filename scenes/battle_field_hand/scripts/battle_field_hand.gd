extends Node


var hand : Array[Card] :
	set = set_hand
var max_hand_size : int :
	set = set_max_hand_size
var available_energy : int :
	set = set_available_energy


var lead_character : Character

var is_player_turn : bool :
	set = set_is_player_turn

var image_data : ImageData = ImageData.new(
	"battle_field_hand",
	"empty",
	"hand.png"
)

const AVAILABLE_ENERGY : String = "available_energy"
const LEAD_CHARACTER : String = "lead_character"
const IS_PLAYER_TURN : String = "is_player_turn"


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.TURN_ENDED, _on_turn_ended)
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CARD_DRAWN, _on_card_drawn)
	BattleRadio.connect(BattleRadio.CURRENT_ENERGY_UPDATED, _on_current_energy_updated)
	BattleRadio.connect(BattleRadio.CURRENT_LEAD_UPDATED, _on_current_lead_updated)
	BattleRadio.connect(BattleRadio.CARDS_DRAWN, _on_cards_drawn)
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)
	BattleRadio.connect(BattleRadio.CARD_FREED, _on_card_freed)


#=======================
# Setters
#=======================
func set_hand(new_hand : Array[Card]) -> void:
	hand = new_hand

	$Area2D.render_hand()
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_HAND_SIZE_UPDATED,
		self.hand.size()
	)

func set_max_hand_size(new_max_hand_size : int) -> void:
	max_hand_size = new_max_hand_size

func set_available_energy(new_available_energy : int) -> void:
	available_energy = new_available_energy

func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("max_hand_size", battle_data.max_hand_size)
	self.set("lead_character", battle_data.lead_character)
	self.set("hand", battle_data.hand)

func _on_turn_started(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", true)

func _on_turn_ended(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", false)
	$Area2D.discard_hand()
	var empty_hand : Array[Card] = []
	self.set("hand", empty_hand)

func _on_card_drawn(drawn_card : Card) -> void:
	var new_hand : Array[Card] = []
	var cur_hand : Array[Card] = self.get_current_hand()

	for card_in_hand in cur_hand:
		new_hand.append(card_in_hand)
	new_hand.append(drawn_card)

	self.set("hand", new_hand)

func _on_cards_drawn(drawn_cards : Array[Card]) -> void:
	var new_hand : Array[Card] = []
	var cur_hand : Array[Card] = self.get_current_hand()

	for card_in_hand in cur_hand:
		new_hand.append(card_in_hand)
	for drawn_card in drawn_cards:
		new_hand.append(drawn_card)

	self.set("hand", new_hand)


func _on_current_energy_updated(current_energy : int) -> void:
	self.set("available_energy", current_energy)

func _on_current_lead_updated(current_lead : Character) -> void:
	self.set("lead_character", current_lead)

func _on_card_played(card : Card) -> void:
	$Area2D.hide_played_card_instance(card)

func _on_card_freed(card : Card) -> void:
	$Area2D.free_played_card_instance(card)

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
