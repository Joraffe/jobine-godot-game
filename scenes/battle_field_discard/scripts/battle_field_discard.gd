extends Node2D


var discard_pile : Array[Card]:
	set = set_discard_pile

var image_data : ImageData = ImageData.new(
	"battle_field_discard",
	"empty",
	"discard.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)


#=======================
# Setters
#=======================
func set_discard_pile(new_discard_pile : Array[Card]) -> void:
	discard_pile = new_discard_pile

	$Area2D/Sprite2D/Panel/Label.update_discard_pile_number(discard_pile.size())


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	discard_pile = battle_data.discard_pile

func _on_card_played(played_card : Card, _targets : Array) -> void:
	var new_discard_pile : Array[Card] = []

	for card_in_discard_pile in self.discard_pile:
		new_discard_pile.append(card_in_discard_pile)
	new_discard_pile.append(played_card)

	discard_pile = new_discard_pile
