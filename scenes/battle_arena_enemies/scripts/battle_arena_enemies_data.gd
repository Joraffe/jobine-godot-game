extends Resource
class_name BattleArenaEnemiesData


var enemies : Array[Enemy]


func _init(enemies_data : Array[Dictionary]) -> void:
	enemies = Enemy.create_multi(enemies_data)
