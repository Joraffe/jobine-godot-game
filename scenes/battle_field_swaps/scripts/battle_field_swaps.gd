extends Node2D


var num_available_swaps : int :
	set = set_num_available_swaps

var is_player_turn : bool


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.STANDBY_SWAP_TO_LEAD_FINISHED, _on_standby_swap_to_lead_finished)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_SWAPS_GAINED, _on_combo_bonus_swaps_gained)


#=======================
# Setters
#=======================
func set_num_available_swaps(new_num_available_swaps : int) -> void:
	num_available_swaps = new_num_available_swaps
	$Area2D/Sprite2D/Panel/MarginContainer/Label.update_num_available_swaps(
		self.num_available_swaps
	)
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_SWAPS_UPDATED,
		self.num_available_swaps
	)


#========================
# Signal Handlers
#========================
func _on_player_turn_started() -> void:
	self.set("num_available_swaps", 2)
	self.set("is_player_turn", true)

func _on_player_turn_ended() -> void:
	self.set("is_player_turn", false)

func _on_standby_swap_to_lead_finished() -> void:
	if self.is_player_turn:
		self.set("num_available_swaps", self.num_available_swaps - 1)

func _on_combo_bonus_swaps_gained(swaps_gained : int) -> void:
	self.set("num_available_swaps", self.num_available_swaps + swaps_gained)
