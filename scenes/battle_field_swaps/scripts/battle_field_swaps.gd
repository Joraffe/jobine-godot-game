extends Node2D


var num_available_swaps : int :
	set = set_num_available_swaps


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.STANDBY_SWAP_TO_LEAD_FINISHED, _on_standby_swap_to_lead_finished)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)


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

func _on_standby_swap_to_lead_finished() -> void:
	self.set("num_available_swaps", self.num_available_swaps - 1)

func _on_combo_bonus_applied(
	_instance_id : int,
	combo_bonus : ComboBonus,
	_targeting : Targeting
) -> void:
	if not combo_bonus.is_extra_swap():
		return

	num_available_swaps = self.num_available_swaps + combo_bonus.swap_amount
