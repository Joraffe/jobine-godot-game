extends Node2D


var data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var seed_data = SeedData.get_seed_data()
	data = BattleData.new(seed_data)

func _ready() -> void:
	BattleRadio.emit_signal(BattleRadio.BATTLE_STARTED, data)
