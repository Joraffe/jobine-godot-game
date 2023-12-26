extends Node


var current_turn_group : String :
	set = set_current_turn_group


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.TURN_ENDED, _on_turn_ended)


#=======================
# Setters
#=======================
func set_current_turn_group(new_current_turn_group : String) -> void:
	current_turn_group = new_current_turn_group

	BattleRadio.emit_signal(
		BattleRadio.TURN_STARTED,
		self.current_turn_group
	)


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	self.set("current_turn_group", BattleConstants.GROUP_PARTY)

func _on_turn_ended(group_name : String) -> void:
	self.set("current_turn_group", self.get_opposite_group_name(group_name))


#========================
# Helpers
#========================
func is_party_group(group_name : String) -> bool:
	return group_name == BattleConstants.GROUP_PARTY

func is_enemies_group(group_name : String) -> bool:
	return group_name == BattleConstants.GROUP_ENEMIES

func get_opposite_group_name(group_name : String) -> String:
	var opposite_group_name : String

	if self.is_party_group(group_name):
		opposite_group_name = BattleConstants.GROUP_ENEMIES
	elif self.is_enemies_group(group_name):
		opposite_group_name = BattleConstants.GROUP_PARTY

	return opposite_group_name
