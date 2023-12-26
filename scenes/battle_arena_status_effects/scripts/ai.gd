extends Node


var entity : Variant


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_ENDED, _on_turn_ended)


#=======================
# Signal Handlers
#=======================
func _on_turn_ended(group_name : String) -> void:
	if not self.is_applicable_to_group(group_name):
		return

	self.entity.reduce_current_status_effects_duration_by(1)
	self.entity.filter_zero_duration_status_effects()


#=======================
# Helpers
#=======================
func is_applicable_to_group(group_name : String) -> bool:
	return self.entity.belongs_to_group(group_name)
