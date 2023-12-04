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
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)

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

func _on_player_turn_started() -> void:
	var num_cards_to_draw : int = BattleFieldHandData.MAX_HAND_SIZE
	var num_remaining_cards : int = data.num_remaining_cards()

	if num_remaining_cards >= num_cards_to_draw:
		BattleRadio.emit_signal(
			BattleRadio.CARDS_DRAWN,
			data.draw_cards(num_cards_to_draw)
		)
	else:
		pass
		# need to shuffle discard pile into deck

func _on_hand_filled() -> void:
	data.can_draw_cards = false
