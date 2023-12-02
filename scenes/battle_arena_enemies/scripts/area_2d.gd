extends Area2D


@onready var battle_arena_enemies = get_parent()


var enemy_scene = preload("res://scenes/battle_arena_enemy/BattleArenaEnemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_texture(battle_arena_enemies.image_data.get_img_texture())


func render_enemies() -> void:
	var enemies_data = battle_arena_enemies.data
	for i in enemies_data.enemies.size():
		var enemy_data = enemies_data.enemies[i].as_dict()
		var enemy_instance = instantiate_enemy(enemy_data)
		position_enemy(i, enemy_instance)


func instantiate_enemy(enemy_data: Dictionary) -> Node2D:
	var instance = enemy_scene.instantiate()
	instance.set(
		"data",
		BattleArenaEnemyData.new(enemy_data)
	)
	add_child(instance)
	return instance


func position_enemy(_index, enemy_instance) -> void:
	# revisit this later when encountering multiple enemies
	# for now we're just working with 1 enemy
	var enemy_area_2d = enemy_instance.get_node("Area2D")
	var new_enemy_pos = Vector2(self.position.x, self.position.y)
	enemy_area_2d.position = new_enemy_pos
