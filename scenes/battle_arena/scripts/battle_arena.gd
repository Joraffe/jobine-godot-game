extends Node2D


var is_card_selected : bool:
	set = set_is_card_selected


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)


#=======================
# Setters
#=======================
func set_is_card_selected(new_selected : bool) -> void:
	is_card_selected = new_selected


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	is_card_selected = false
