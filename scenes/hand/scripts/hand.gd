extends Node


var hand_data : HandData:
	set = set_hand_data
var image_data : ImageData = ImageData.new("hand", "empty", "hand.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init():
	BattleRadio.connect("start_battle", _on_start_battle)
	BattleRadio.connect("draw_card", _on_draw_card)

func _ready():
	pass


#=======================
# Setters
#=======================
func set_hand_data(new_hand_data : HandData) -> void:
	hand_data = new_hand_data
	
	$"Area2D".render_hand()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData):
	hand_data = battle_data.hand_data

func _on_draw_card(card_data : CardData):
	var hand = hand_data.get_current_hand()
	hand.append(card_data)
	hand_data = HandData.new(hand)

	if hand_data.is_hand_full():
		BattleRadio.emit_signal("hand_is_full")
