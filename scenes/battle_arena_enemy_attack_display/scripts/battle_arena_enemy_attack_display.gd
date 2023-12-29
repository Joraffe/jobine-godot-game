extends Node2D


var enemy_attack : EnemyAttack :
	set = set_enemy_attack
var entity_image_height : int :
	set = set_entity_image_height


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

func set_entity_image_height(new_height : int) -> void:
	entity_image_height = new_height

	self.position_attack_display()

#=======================
# Signal Handlers
#=======================
func _on_enemy_attack_timeout() -> void:
	self.hide()
	$Timer.stop()


#=======================
# Node Helpers
#=======================
func position_attack_display() -> void:
	var position_y : int = ((-1) * int(self.entity_image_height / 2.0) - 50)
	self.position.y = position_y

func animate() -> void:
	self.show()
	$Timer.start()
