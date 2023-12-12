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
		Character.JUNO,
		SeedData._get_juno_character_data()
	)

	# Pettol Character Data
	config_file.set_value(
		CHARACTERS,
		Character.PETTOL,
		SeedData._get_pettol_character_data()
	)

	# Axo Character Data
	config_file.set_value(
		CHARACTERS,
		Character.AXO,
		SeedData._get_axo_character_data()
	)

	config_file.save(SEED_DATA_CFG_PATH)


#==================
# Enemy Data
#==================
const ENEMIES : String = "enemies"
static func seed_enemy_data(config_file : ConfigFile) -> void:
	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.FIRE_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.FIRE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.WATER_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.WATER),
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.NATURE_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.NATURE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.VOLT_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.VOLT)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.ICE_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.ICE)
	)

	config_file.set_value(
		SeedData.ENEMIES,
		Enemy.AERO_SLIME,
		SeedData._get_elemental_slime_enemy_data(Element.AERO)
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
		Character.JUNO,
		SeedData._get_juno_card_names()
	)

	# Pettol Card Data
	config_file.set_value(
		CARDS,
		Character.PETTOL,
		SeedData._get_pettol_card_names()
	)

	# Axo Card Data
	config_file.set_value(
		CARDS,
		Character.AXO,
		SeedData._get_axo_card_names()
	)

	config_file.save(SEED_DATA_CFG_PATH)


#=====================
# Seed Data Helpers
#=====================
static func _get_juno_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Juno",
		Character.MACHINE_NAME : Character.JUNO,
		Character.ELEMENT_NAME : Element.NATURE,
		Character.MAX_HP : 10,
		Character.CURRENT_HP : 10,
		Character.ENTITY_TYPE : Character.ENTITY_TYPE_CHARACTER
	}

static func _get_juno_card_names() -> Array[String]:
	var cards : Array[String] = []
	cards.append(Card.FLORAL_DART)
	cards.append(Card.FLORAL_DART)
	cards.append(Card.BLOOM)
	return cards

static func _get_pettol_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Pettol",
		Character.MACHINE_NAME : Character.PETTOL,
		Character.ELEMENT_NAME : Element.VOLT,
		Character.MAX_HP : 15,
		Character.CURRENT_HP : 15,
		Character.ENTITY_TYPE : Character.ENTITY_TYPE_CHARACTER
	}

static func _get_pettol_card_names() -> Array[String]:
	var cards : Array[String] = []
	cards.append(Card.CHOMP)
	cards.append(Card.CHOMP)
	cards.append(Card.PETTOL_BEAM)
	return cards

static func _get_axo_character_data() -> Dictionary:
	return {
		Character.HUMAN_NAME : "Axo",
		Character.MACHINE_NAME : Character.AXO,
		Character.ELEMENT_NAME : Element.FIRE,
		Character.MAX_HP : 7,
		Character.CURRENT_HP : 7,
		Character.ENTITY_TYPE : Character.ENTITY_TYPE_CHARACTER
	}

static func _get_axo_card_names() -> Array[String]:
	var cards : Array[String] = []
	cards.append(Card.AQUA_SHOT)
	cards.append(Card.AQUA_SHOT)
	cards.append(Card.SWIFT_SWIM)
	return cards

static func _get_elemental_slime_enemy_data(element_name : String) -> Dictionary:
	return {
		Enemy.HUMAN_NAME : "{element} Slime".format({
			"elemnet" : element_name.capitalize()
		}),
		Enemy.MACHINE_NAME : Enemy.slime_enemy_name_by_element(element_name),
		Enemy.ELEMENT_NAME : element_name,
		Enemy.MAX_HP : 10,
		Enemy.CURRENT_HP : 10,
		Enemy.ENTITY_TYPE : Enemy.ENTITY_TYPE_ENEMY
	}
