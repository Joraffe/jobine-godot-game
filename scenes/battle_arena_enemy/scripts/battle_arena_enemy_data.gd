extends Resource
class_name BattleArenaEnemyData


var enemy : Enemy


func _init(enemy_data : Dictionary) -> void:
	enemy = Enemy.create(enemy_data)
