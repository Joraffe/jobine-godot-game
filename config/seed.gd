extends Resource
class_name SeedData


const STARTER_CARDS_CFG_PATH : String = "user://starter_cards.cfg"
const STARTER_CARDS_CONFIG_KEY : String = "starter_cards"



static func seed_starter_cards(cofig_file : ConfigFile) -> void:
	var juno_cards : Array[Dictionary] = []
	juno_cards.append({
		"name" : CardArchive.NATURE_SINGLE_CARD,
		"character": CharacterArchive.JUNO_CHARACTER
	})
	juno_cards.append({
		"name" : CardArchive.NATURE_SINGLE_CARD,
		"character": CharacterArchive.JUNO_CHARACTER
	})
	juno_cards.append({
		"name" : CardArchive.NATURE_SINGLE_CARD,
		"character": CharacterArchive.JUNO_CHARACTER
	})
	cofig_file.set_value(
		CharacterArchive.JUNO_CHARACTER,
		STARTER_CARDS_CONFIG_KEY,
		juno_cards
	)

	var pettol_cards : Array[Dictionary] = []
	pettol_cards.append({
		"name" : CardArchive.WATER_SINGLE_CARD,
		"character": CharacterArchive.PETTOL_CHARACTER
	})
	pettol_cards.append({
		"name" : CardArchive.WATER_SINGLE_CARD,
		"character": CharacterArchive.PETTOL_CHARACTER
	})
	pettol_cards.append({
		"name" : CardArchive.WATER_SINGLE_CARD,
		"character": CharacterArchive.PETTOL_CHARACTER
	})
	cofig_file.set_value(
		CharacterArchive.PETTOL_CHARACTER,
		STARTER_CARDS_CONFIG_KEY,
		pettol_cards
	)

	var axo_cards : Array[Dictionary] = []
	axo_cards.append({
		"name" : CardArchive.FIRE_SINGLE_CARD,
		"character": CharacterArchive.AXO_CHARACTER
	})
	axo_cards.append({
		"name" : CardArchive.FIRE_SINGLE_CARD,
		"character": CharacterArchive.AXO_CHARACTER
	})
	axo_cards.append({
		"name" : CardArchive.FIRE_SINGLE_CARD,
		"character": CharacterArchive.AXO_CHARACTER
	})
	cofig_file.set_value(
		CharacterArchive.AXO_CHARACTER,
		STARTER_CARDS_CONFIG_KEY,
		axo_cards
	)

	cofig_file.save(STARTER_CARDS_CFG_PATH)


static func get_starter_cards(characters : Array[String]) -> Dictionary:
	var starter_cards = {}
	var config_file = ConfigFile.new()

	# Seed the data if the config file doesn't exist
	var load_status = config_file.load(STARTER_CARDS_CFG_PATH)
	if load_status != OK:
		SeedData.seed_starter_cards(config_file)

	for character_name in config_file.get_sections():
		if character_name not in characters:
			continue

		starter_cards[character_name] = config_file.get_value(
			character_name,
			STARTER_CARDS_CONFIG_KEY
		)

	return starter_cards
