extends Area2D


@onready var enemies = get_parent()


var enemy_scene = preload("res://scenes/enemy/scenes/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(enemies.image_data.get_img_texture())


func render_enemies():
	var enemies_data = enemies.enemies_data
	for i in enemies_data.enemy_members.size():
		var enemy_data = enemies_data.enemy_members[i]
		var enemy_instance = instantiate_enemy(enemy_data)
		position_enemy(i, enemy_instance)


func instantiate_enemy(enemy_data: EnemyData):
	var instance = enemy_scene.instantiate()
	instance.set("enemy_data", enemy_data)
	add_child(instance)
	return instance


func position_enemy(_index, enemy_instance):
	# revisit this later when encountering multiple enemies
	# for now we're just working with 1 enemy
	var enemy_area_2d = enemy_instance.get_node("Area2D")
	var new_enemy_pos = Vector2(self.position.x, self.position.y)
	enemy_area_2d.position = new_enemy_pos
