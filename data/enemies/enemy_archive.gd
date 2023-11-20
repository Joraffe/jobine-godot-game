extends Resource
class_name EnemyArchive


static func get_enemy(name : String) -> Enemy:
	match name:
		FIRE_SLIME_ENEMY:
			return Enemy.new(
				FIRE_SLIME_ENEMY,
				ElementArchive.FIRE_ELEMENT,
				10,
				10
			)
		WATER_SLIME_ENEMY:
			return Enemy.new(
				WATER_SLIME_ENEMY,
				ElementArchive.WATER_ELEMENT,
				10,
				10
			)
		NATURE_SLIME_ENEMY:
			return Enemy.new(
				NATURE_SLIME_ENEMY,
				ElementArchive.NATURE_ELEMENT,
				10,
				10
			)
		_:
			return Enemy.new(
				UNKNOWN_ENEMY,
				ElementArchive.UNKNOWN_ELEMENT,
				0,
				0
			)


static func get_random_enemy_name() -> String:
	var rng = RandomNumberGenerator.new()
	var keys = ENEMIES.keys()
	var rand_i = rng.randi_range(0, keys.size() - 1)
	var rand_key = keys[rand_i]
	return ENEMIES[rand_key]

#=========================
#   List of Characters
#=========================
const ENEMIES : Dictionary = {
	FIRE_SLIME_ENEMY: FIRE_SLIME_ENEMY,
	WATER_SLIME_ENEMY: WATER_SLIME_ENEMY,
	NATURE_SLIME_ENEMY: NATURE_SLIME_ENEMY
}
const FIRE_SLIME_ENEMY : String = "fire_slime_enemy"
const WATER_SLIME_ENEMY : String = "water_slime_enemy"
const NATURE_SLIME_ENEMY : String = "nature_slime_enemy"
const UNKNOWN_ENEMY : String = "unknown_enemy"
