extends Node2D

var data : BattleFieldDiscardData:
	set = set_battle_field_discard_data
var image_data : ImageData = ImageData.new("battle_field_discard", "empty", "discard.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)

func _ready() -> void:
	pass # Replace with function body.


#=======================
# Setters
#=======================
func set_battle_field_discard_data(new_battle_field_discard_data : BattleFieldDiscardData) -> void:
	data = new_battle_field_discard_data


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	data = battle_data.battle_field_discard_data
