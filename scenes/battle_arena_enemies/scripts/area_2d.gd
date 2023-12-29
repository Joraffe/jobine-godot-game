extends Area2D


@onready var battle_arena_enemies = get_parent()
var enemy_scene = preload("res://scenes/battle_arena_enemy/BattleArenaEnemy.tscn")


#=======================
# Area2D Functionality
#=======================
func render_enemies() -> void:
	var enemies : Array[Enemy] = battle_arena_enemies.enemies
	for i in enemies.size():
		var enemy = enemies[i]
		var enemy_instance = instantiate_enemy(enemy)
		position_enemy(i, enemy_instance)

func position_enemy(index, enemy_instance) -> void:
	var enemies_image_data : ImageData = battle_arena_enemies.image_data
	var enemy_image_data : ImageData = enemy_instance.image_data
	var total_enemies : int = battle_arena_enemies.enemies.size()
	var num_spacing : int = total_enemies + 1

	var enemies_width : int = enemies_image_data.get_img_width()
	var enemy_width : int = enemy_image_data.get_img_width()
	var total_enemy_width : int = enemy_width * total_enemies
	var total_spacing_width : int = enemies_width - total_enemy_width
	var spacing_width : int = int(float(total_spacing_width) / float(num_spacing))

	var starting_x : int = ((-1) * int(enemies_width / 2.0) + int(enemy_width / 2.0))
	var initial_x_spacing : int = spacing_width
	var enemy_pos_x : int = (
		starting_x
		+ initial_x_spacing
		+ (index * (enemy_width + spacing_width))
	)

	# possibly make use of offset_y with `get_offset_y_position`
	var new_enemy_pos = Vector2(enemy_pos_x, 0)
	enemy_instance.position = new_enemy_pos

#=======================
# Data Helpers
#=======================
func instantiate_enemy(enemy : Enemy) -> Node2D:
	var instance = enemy_scene.instantiate()
	instance.set("enemy", enemy)
	add_child(instance)
	instance.get_node("HealthBar").update_health_bar()
	return instance


func get_offset_y_position(index : int, enemy_instance) -> int:
	var enemies_image_data : ImageData = battle_arena_enemies.image_data
	var enemy_image_data : ImageData = enemy_instance.image_data
	var total_enemies : int = battle_arena_enemies.enemies.size()
	var num_spacing : int = total_enemies + 1

	var enemies_height : int = enemies_image_data.get_img_height()
	var enemy_height : int = enemy_image_data.get_img_height()
	var total_enemy_height : int = int(enemy_height / 2.0) * total_enemies
	var total_spacing_height : int = enemies_height - total_enemy_height
	var spacing_height : int = int(float(total_spacing_height) / float(num_spacing))
	var starting_y : int = ((-1) * int(float(enemies_height) / 2.0) + int(float(enemy_height) / 2.0))
	var inital_y_spacing : int = spacing_height
	var enemy_pos_y : int = (
		starting_y
		+ inital_y_spacing
		+ (index * (int(float(enemy_height) / 2.0) + spacing_height))
	)
	return enemy_pos_y
