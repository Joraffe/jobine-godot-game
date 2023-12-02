extends Node


var default_mouse_image = preload("res://scenes/battle_mouse/resources/images/mouse.png")


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)


#========================
# Signal Handlers
#========================
func _on_battle_started(_battle_data : BattleData) -> void:
	Input.set_custom_mouse_cursor(default_mouse_image)
