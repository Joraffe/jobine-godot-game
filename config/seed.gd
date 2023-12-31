extends Resource
class_name SeedData


const SEED_DATA_CFG_PATH : String = "user://seed_data.cfg"


static func get_seed_data() -> Dictionary:
	var seed_data = {}
	var config_file = ConfigFile.new()

	# Seed the data if the config file doesn't exist
	var load_status = config_file.load(SEED_DATA_CFG_PATH)
	if load_status != OK:
		SeedCharacters.seed_character_data(config_file)
		SeedCards.seed_card_data(config_file)
		SeedEnemies.seed_enemy_data(config_file)

	# Iterate and get each section seed data
	for section in config_file.get_sections():
		seed_data[section] = {}
		for section_key in config_file.get_section_keys(section):
			seed_data[section][section_key] = config_file.get_value(
				section,
				section_key
			)
			

	return seed_data


# Types of Seed Data
const CARDS : String = "cards"
const CHARACTERS : String = "characters"
const ENEMIES : String = "enemies"
