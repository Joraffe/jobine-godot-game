extends Area2D


@onready var battle_arena_enemies = get_parent()
var enemy_scene = preload("res://scenes/battle_arena_enemy/BattleArenaEnemy.tscn")


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$Sprite2D.set_texture(battle_arena_enemies.image_data.get_img_texture())


#=======================
# Area2D Functionality
#=======================
func render_enemies() -> void:
	var enemies : Array[Enemy] = battle_arena_enemies.enemies
	for i in enemies.size():
		var enemy = enemies[i]
		var enemy_instance = instantiate_enemy(enemy)
		position_enemy(i, enemy_instance)

func position_enemy(_index, enemy_instance) -> void:
	# revisit this later when encountering multiple enemies
	# for now we're just working with 1 enemy
	var enemy_area_2d = enemy_instance.get_node("Area2D")
	var new_enemy_pos = Vector2(self.position.x, self.position.y)
	enemy_area_2d.position = new_enemy_pos


#=======================
# Data Helpers
#=======================
func instantiate_enemy(enemy : Enemy) -> Node2D:
	var instance = enemy_scene.instantiate()
	instance.set("enemy", enemy)
	add_child(instance)
	instance.get_node("HealthBar").update_health_bar()
	return instance
