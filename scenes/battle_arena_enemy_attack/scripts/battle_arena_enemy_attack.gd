extends Node2D


var enemy_attack : EnemyAttack :
	set = set_enemy_attack


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$Timer.connect("timeout", _on_enemy_attack_timeout)


#=======================
# Setters
#=======================
func set_enemy_attack(new_attack : EnemyAttack) -> void:
	enemy_attack = new_attack

	$Panel/MarginContainer/Label.set_attack_text(enemy_attack)


#=======================
# Signal Handlers
#=======================
func _on_enemy_attack_timeout() -> void:
	self.hide()
	$Timer.stop()


#=======================
# Node Helpers
#=======================
func show_then_hide_after_delay() -> void:
	self.show()
	$Timer.start()
