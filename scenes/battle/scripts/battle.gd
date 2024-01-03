extends Node2D


var data : Dictionary  # from SceneSwitcher

var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	self.set(
		"battle_data",
		BattleData.new(
			SeedData.get_seed_data(),
			self.data
		)
	) 

	BattleRadio.emit_signal(
		BattleRadio.BATTLE_STARTED,
		battle_data,
	)
