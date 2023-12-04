extends Node2D


var data : BattleArenaData:
	set = set_battle_arena_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)


#=======================
# Setters
#=======================
func set_battle_arena_data(new_data : BattleArenaData) -> void:
	data = new_data

	# Maybe do additional stuff w/ Arena2D in the future


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	data = BattleArenaData.new({
		BattleArenaData.IS_CARD_SELECTED : false
	})
