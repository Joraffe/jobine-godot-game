extends Node2D


var party_data : PartyData:
	set = set_party_data
var image_data : ImageData = ImageData.new("party", "empty", "party.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)

func _ready() -> void:
	pass


#=======================
# Setters
#=======================
func set_party_data(new_party_data: PartyData) -> void:
	party_data = new_party_data

	$"Area2D".render_party()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	party_data = battle_data.party_data
