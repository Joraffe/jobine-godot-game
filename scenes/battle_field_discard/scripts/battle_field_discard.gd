extends Node2D


var discard_pile : Array[Card] :
	set = set_discard_pile
var discard_pile_count : int :
	set = set_discard_pile_count

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
	BattleRadio.connect(BattleRadio.CARD_DISCARDED, _on_card_discarded)


#=======================
# Setters
#=======================
func set_discard_pile(new_discard_pile : Array[Card]) -> void:
	discard_pile = new_discard_pile
	self.set("discard_pile_count", self.discard_pile.size())

func set_discard_pile_count(new_count : int) -> void:
	discard_pile_count = new_count
	$Area2D/Sprite2D/Panel/Label.update_discard_pile_number(discard_pile_count)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	discard_pile = battle_data.discard_pile

func _on_card_played(played_card : Card, _targeting : Targeting) -> void:
	add_card_to_discard_pile(played_card)

func _on_card_discarded(discarded_card : Card) -> void:
	add_card_to_discard_pile(discarded_card)


#============================
# Discard Pile Functionality
#============================
func add_card_to_discard_pile(card : Card) -> void:
	self.discard_pile.append(card)
	self.set("discard_pile_count", self.discard_pile_count + 1)
