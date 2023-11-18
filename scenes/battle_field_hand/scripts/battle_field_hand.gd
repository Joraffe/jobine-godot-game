extends Node


var data : BattleFieldHandData:
	set = set_hand_data
var image_data : ImageData = ImageData.new("battle_field_hand", "empty", "hand.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)
	BattleRadio.connect("draw_card", _on_draw_card)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_hand_data(new_battle_field_hand_data : BattleFieldHandData) -> void:
	data = new_battle_field_hand_data
	
	$"Area2D".render_hand()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	data = battle_data.battle_field_hand_data

func _on_draw_card(card_data : BattleFieldCardData) -> void:
	var hand = data.get_current_hand()
	hand.append(card_data)
	data = BattleFieldHandData.new(hand)

	if data.is_hand_full():
		BattleRadio.emit_signal("hand_is_full")
