extends Resource
class_name SeedData


const SEED_DATA_CFG_PATH : String = "user://seed_data.cfg"


static func get_seed_data() -> Dictionary:
	var seed_data = {}
	var config_file = ConfigFile.new()

	# Seed the data if the config file doesn't exist
	var load_status = config_file.load(SEED_DATA_CFG_PATH)
	if load_status != OK:
		SeedData.seed_character_data(config_file)
		SeedData.seed_card_data(config_file)
		SeedData.seed_enemy_data(config_file)

	# Iterate and get each section seed data
	for section in config_file.get_sections():
		seed_data[section] = {}
		for section_key in config_file.get_section_keys(section):
			seed_data[section][section_key] = config_file.get_value(
				section,
				section_key
			)
			

	return seed_data


#==================
# Character Data
#==================
const CHARACTERS : String = "characters"
static func seed_character_data(config_file : ConfigFile) -> void:
	# Juno Character Data
	config_file.set_value(
		CHARACTERS,
		CharacterArchive.JUNO_CHARACTER,
		SeedData._get_juno_character_data()
	)

	# Pettol Character Data
	config_file.set_value(
		CHARACTERS,
		CharacterArchive.PETTOL_CHARACTER,
		SeedData._get_pettol_character_data()
	)

	# Axo Character Data
	config_file.set_value(
		CHARACTERS,
		CharacterArchive.AXO_CHARACTER,
		SeedData._get_axo_character_data()
	)

	config_file.save(SEED_DATA_CFG_PATH)


#==================
# Enemy Data
#==================
const ENEMIES : String = "enemies"
static func seed_enemy_data(config_file : ConfigFile) -> void:
	config_file.set_value(
		ENEMIES,
		EnemyArchive.FIRE_SLIME_ENEMY,
		SeedData._get_fire_slime_enemy_data()
	)

	config_file.set_value(
		ENEMIES,
		EnemyArchive.WATER_SLIME_ENEMY,
		SeedData._get_water_slime_enemy_data(),
	)

	config_file.set_value(
		ENEMIES,
		EnemyArchive.NATURE_SLIME_ENEMY,
		SeedData._get_nature_slime_enemy_data()
	)

	config_file.save(SEED_DATA_CFG_PATH)


#==================
# Card Data
#==================
const CARDS : String = "cards"
static func seed_card_data(config_file : ConfigFile) -> void:
	# Juno Card Data
	config_file.set_value(
		CARDS,
		CharacterArchive.JUNO_CHARACTER,
		SeedData._get_juno_card_data()
	)

	# Pettol Card Data
	config_file.set_value(
		CARDS,
		CharacterArchive.PETTOL_CHARACTER,
		SeedData._get_pettol_card_data()
	)

	# Axo Card Data
	config_file.set_value(
		CARDS,
		CharacterArchive.AXO_CHARACTER,
		SeedData._get_axo_card_data()
	)

	config_file.save(SEED_DATA_CFG_PATH)


#=====================
# Seed Data Helpers
#=====================
static func _get_juno_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Juno",
		Character.MACHINE_NAME : CharacterArchive.JUNO_CHARACTER,
		Character.ELEMENT_NAME : ElementArchive.NATURE_ELEMENT,
		Character.MAX_HP : 10,
		Character.CURRENT_HP : 10
	}

static func _get_juno_card_data() -> Array[Dictionary]:	
	var cards : Array[Dictionary] = []

	for i in range(3):
		var tokens : Array[String] = [TokenArchive.NATURE_TOKEN]
		
		cards.append({
			Card.HUMAN_NAME : CardArchive.NATURE_SINGLE_CARD,
			Card.MACHINE_NAME : CardArchive.NATURE_SINGLE_CARD,
			Card.COST : 1,
			Card.ELEMENT_NAME : ElementArchive.NATURE_ELEMENT,
			Card.CHARACTER_NAME : CharacterArchive.JUNO_CHARACTER,
			Card.TARGETING_NAME : TargetingArchive.ENEMIES_SINGLE_TARGETING,
			Card.TOKEN_NAMES : tokens,
		})

	return cards

static func _get_pettol_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Pettol",
		Character.MACHINE_NAME : CharacterArchive.PETTOL_CHARACTER,
		Character.ELEMENT_NAME : ElementArchive.WATER_ELEMENT,
		Character.MAX_HP : 15,
		Character.CURRENT_HP : 15
	}

static func _get_pettol_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []

	for i in range(3):
		var tokens : Array[String] = [TokenArchive.WATER_TOKEN]

		cards.append({
			Card.HUMAN_NAME : CardArchive.WATER_SINGLE_CARD,
			Card.MACHINE_NAME : CardArchive.WATER_SINGLE_CARD,
			Card.COST : 1,
			Card.ELEMENT_NAME : ElementArchive.WATER_ELEMENT,
			Card.CHARACTER_NAME : CharacterArchive.PETTOL_CHARACTER,
			Card.TARGETING_NAME : TargetingArchive.ENEMIES_SINGLE_TARGETING,
			Card.TOKEN_NAMES : tokens,
		})

	return cards

static func _get_axo_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Axo",
		Character.MACHINE_NAME : CharacterArchive.AXO_CHARACTER,
		Character.ELEMENT_NAME : ElementArchive.FIRE_ELEMENT,
		Character.MAX_HP : 7,
		Character.CURRENT_HP : 7
	}

static func _get_axo_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []

	for i in range(3):
		var tokens : Array[String] = [TokenArchive.FIRE_TOKEN]
		
		cards.append({
			Card.HUMAN_NAME : CardArchive.FIRE_SINGLE_CARD,
			Card.MACHINE_NAME : CardArchive.FIRE_SINGLE_CARD,
			Card.COST : 1,
			Card.ELEMENT_NAME : ElementArchive.FIRE_ELEMENT,
			Card.CHARACTER_NAME : CharacterArchive.AXO_CHARACTER,
			Card.TARGETING_NAME : TargetingArchive.ENEMIES_SINGLE_TARGETING,
			Card.TOKEN_NAMES : tokens,
		})

	return cards

static func _get_fire_slime_enemy_data() -> Dictionary:
	return {
		Enemy.HUMAN_NAME : "Fire Slime",
		Enemy.MACHINE_NAME : EnemyArchive.FIRE_SLIME_ENEMY,
		Enemy.ELEMENT_NAME : ElementArchive.FIRE_ELEMENT,
		Enemy.MAX_HP : 10,
		Enemy.CURRENT_HP : 10
	}

static func _get_water_slime_enemy_data() -> Dictionary:
	return {
		Enemy.HUMAN_NAME : "Water Slime",
		Enemy.MACHINE_NAME : EnemyArchive.WATER_SLIME_ENEMY,
		Enemy.ELEMENT_NAME : ElementArchive.WATER_ELEMENT,
		Enemy.MAX_HP : 10,
		Enemy.CURRENT_HP : 10
	}

static func _get_nature_slime_enemy_data() -> Dictionary:
	return {
		Enemy.HUMAN_NAME : "Nature Slime",
		Enemy.MACHINE_NAME : EnemyArchive.NATURE_SLIME_ENEMY,
		Enemy.ELEMENT_NAME : ElementArchive.NATURE_ELEMENT,
		Enemy.MAX_HP : 10,
		Enemy.CURRENT_HP : 10
	}
