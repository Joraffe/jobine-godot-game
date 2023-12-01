extends Node2D


var data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var seed_data = SeedData.get_seed_data()
	data = BattleData.create(seed_data)

func _ready() -> void:
	BattleRadio.emit_signal("battle_started", data)
