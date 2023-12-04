extends Node


var data : BattleTurnData:
	set = set_battle_turn_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)


#=======================
# Setters
#=======================
func set_battle_turn_data(new_data : BattleTurnData) -> void:
	data = new_data

	# Maybe do additional stuff if needed


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	data = BattleTurnData.new({BattleTurnData.IS_PLAYER_TURN : true})
	BattleRadio.emit_signal(BattleRadio.PLAYER_TURN_STARTED)
