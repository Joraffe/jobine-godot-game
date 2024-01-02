extends Resource
class_name SeedEnemies


#==================
# Enemy Data
#==================
static func seed_enemy_data(config_file : ConfigFile) -> void:
	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.FIRE_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.FIRE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.WATER_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.WATER),
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.NATURE_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.NATURE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.VOLT_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.VOLT)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.ICE_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.ICE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.AERO_SLIME,
		SeedEnemies._get_elemental_slime_enemy_data(Element.AERO)
	)

	config_file.save(SeedData.SEED_DATA_CFG_PATH)


#==================
# Helpers
#==================
static func _get_elemental_slime_enemy_data(element_name : String) -> Dictionary:
	var attack_names : Array[String] = [
		EnemyAttack.SLIME_STRIKE,
		EnemyAttack.OOZE
	]
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Enemy.HUMAN_NAME : "{element} Slime".format({
			"element" : element_name.capitalize()
		}),
		Enemy.MACHINE_NAME : Enemy.slime_enemy_name_by_element(element_name),
		Enemy.ELEMENT_NAME : element_name,
		Enemy.MAX_HP : 10,
		Enemy.CURRENT_HP : 10,
		Enemy.CURRENT_ELEMENT_NAMES : current_element_names,
		Enemy.ENTITY_TYPE : BattleConstants.ENTITY_ENEMY,
		Enemy.ATTACK_NAMES : attack_names,
		Enemy.CURRENT_STATUS_EFFECTS : current_status_effects
	}
