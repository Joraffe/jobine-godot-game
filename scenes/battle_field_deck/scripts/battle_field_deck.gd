extends Node2D


var cards : Array[Card]:
	set = set_cards
var can_draw : bool:
	set = set_can_draw
var max_hand_size : int:
	set = set_max_hand_size

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
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)


#=======================
# Setters
#=======================
func set_cards(new_cards : Array[Card]) -> void:
	cards = new_cards

	self.shuffled_cards = {}
	self.shuffle_cards()

func set_can_draw(new_can_draw : bool) -> void:
	can_draw = new_can_draw

func set_max_hand_size(new_max_hand_size : int) -> void:
	max_hand_size = new_max_hand_size


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	cards = battle_data.cards
	max_hand_size = battle_data.max_hand_size

func _on_player_turn_started() -> void:
	# If there's enough cards to draw a full hand
	if self.num_remaining_cards() >= self.max_hand_size:
		BattleRadio.emit_signal(
			BattleRadio.CARDS_DRAWN,
			self.draw_cards(self.max_hand_size)
		)
		$Area2D/Sprite2D/Panel/Label.update_deck_number(
			self.shuffled_cards.size()
		)
	# If there's not enough cards in deck
	# shuffle the discard pile into deck
	# and then draw cards
	else:
		pass


func _on_current_hand_size_updated(current_hand_size : int) -> void:
	if current_hand_size == self.max_hand_size:
		can_draw = false

func _on_combo_bonus_applied(combo_bonus_data : Dictionary) -> void:
	var combo_bonus : ComboBonus = combo_bonus_data[ComboBonus.COMBO_BONUS]
	if not combo_bonus.is_extra_cards():
		return

	if not self.can_draw:
		return

	var num_bonus_cards : int = combo_bonus.card_draw_amount

	# if there's enough cards in deck to draw cards
	if self.num_remaining_cards() >= num_bonus_cards:
		BattleRadio.emit_signal(
			BattleRadio.CARDS_DRAWN,
			self.draw_cards(num_bonus_cards)
		)
	else:
	# If there's not enough cards in deck
	# shuffle the discard pile into deck
	# and then draw cards
		pass


#=======================
# Data Helpers
#=======================
func shuffle_cards() -> void:
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
