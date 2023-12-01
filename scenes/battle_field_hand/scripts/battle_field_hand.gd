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
	BattleRadio.connect("battle_started", _on_battle_started)
	BattleRadio.connect("card_drawn", _on_card_drawn)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_hand_data(new_data : BattleFieldHandData) -> void:
	data = new_data
	
	$Area2D.empty_hand()
	$Area2D.render_hand()


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
		BattleRadio.emit_signal("hand_filled")
