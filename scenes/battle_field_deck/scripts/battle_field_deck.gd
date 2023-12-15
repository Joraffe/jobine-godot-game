extends Node2D


var cards : Array[Card] :
	set = set_cards
var can_draw : bool :
	set = set_can_draw
var max_hand_size : int :
	set = set_max_hand_size
var is_player_turn : bool :
	set = set_is_player_turn

var remaining_cards_to_draw : int

var shuffled_cards : Dictionary
var rng = RandomNumberGenerator.new()
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
	BattleRadio.connect(BattleRadio.CURRENT_HAND_SIZE_UPDATED, _on_current_hand_size_updated)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)
	BattleRadio.connect(
		BattleRadio.DISCARD_PILE_SHUFFLED_INTO_DECK,
		_on_discard_pile_shuffled_into_deck
	)

#=======================
# Setters
#=======================
func set_cards(new_cards : Array[Card]) -> void:
	cards = new_cards

	self.shuffle_cards()

func set_can_draw(new_can_draw : bool) -> void:
	can_draw = new_can_draw

func set_max_hand_size(new_max_hand_size : int) -> void:
	max_hand_size = new_max_hand_size

func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn

	if self.is_player_turn:
		self.draw_and_emit_cards(self.max_hand_size)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("cards", battle_data.cards)
	self.set("max_hand_size", battle_data.max_hand_size)

func _on_player_turn_started() -> void:
	self.set("is_player_turn", true)

func _on_player_turn_ended() -> void:
	self.set("is_player_turn", false)

func _on_current_hand_size_updated(current_hand_size : int) -> void:
	if current_hand_size == self.max_hand_size:
		self.set("can_dra", false)

func _on_combo_bonus_applied(
	_instance_id : int,
	combo_bonus : ComboBonus,
	_targeting : Targeting
) -> void:
	if not combo_bonus.is_extra_cards():
		return

	if not self.can_draw:
		return

	var num_bonus_cards : int = combo_bonus.card_draw_amount
	self.draw_and_emit_cards(num_bonus_cards)

func _on_discard_pile_shuffled_into_deck() -> void:
	self.shuffle_cards()
	if self.remaining_cards_to_draw > 0:
		self.draw_and_emit_cards(self.remaining_cards_to_draw)


#=======================
# Data Helpers
#=======================
func shuffle_cards() -> void:
	self.set("shuffled_cards", {})

	var indexes : Dictionary = {}
	for i in self.cards.size():
		indexes[i] = i

	while indexes.keys().size() > 0:
		var keys = indexes.keys()
		var rand_i = self.rng.randi_range(0, keys.size() - 1)
		var rand_key = keys[rand_i]
		self.shuffled_cards[rand_key] = self.cards[rand_key]
		indexes.erase(rand_key)

func has_cards() -> bool:
	return self.shuffled_cards.size() != 0

func num_remaining_cards() -> int:
	return self.shuffled_cards.size()

func draw_card() -> Card:
	var keys = self.shuffled_cards.keys()
	var rand_key = keys[rng.randi_range(0, keys.size() - 1)]
	var card = self.shuffled_cards[rand_key]
	self.shuffled_cards.erase(rand_key)

	return card

func draw_cards(num_cards : int):
	var cards_to_draw : Array[Card] = []

	for i in range(num_cards):
		cards_to_draw.append(draw_card())

	return cards_to_draw


#=======================
# Signal Helpers
#=======================
func draw_and_emit_cards(num_cards : int) -> void:
	# If there's enough cards to draw a full hand
	if self.num_remaining_cards() >= num_cards:
		self.set("remaining_cards_to_draw", 0)
		BattleRadio.emit_signal(
			BattleRadio.CARDS_DRAWN,
			self.draw_cards(num_cards)
		)
	# If there's not enough cards in deck
	# shuffle the discard pile into deck
	# and then draw cards
	else:
		self.set("remaining_cards_to_draw", num_cards - self.num_remaining_cards())
		BattleRadio.emit_signal(
			BattleRadio.CARDS_DRAWN,
			self.draw_cards(self.num_remaining_cards())
		)
		BattleRadio.emit_signal(BattleRadio.DECK_EMPTIED)

	$Area2D/Sprite2D/Panel/Label.update_deck_number(
			self.shuffled_cards.size()
		)
