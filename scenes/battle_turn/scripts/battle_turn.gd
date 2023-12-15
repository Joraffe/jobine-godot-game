extends Node


var is_player_turn : bool :
	set = set_player_turn


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.ENEMY_TURN_ENDED, _on_enemy_turn_ended)


#=======================
# Setters
#=======================
func set_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn

	# Maybe do additional stuff if needed
	if self.is_player_turn:
		BattleRadio.emit_signal(BattleRadio.PLAYER_TURN_STARTED)
	else:
		BattleRadio.emit_signal(BattleRadio.ENEMY_TURN_STARTED)


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	self.set("is_player_turn", true)

func _on_player_turn_ended() -> void:
	self.set("is_player_turn", false)
	
func _on_enemy_turn_ended() -> void:
	self.set("is_player_turn", true)
