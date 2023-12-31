extends Resource
class_name SeedCharacters


#==================
# Character Data
#==================
static func seed_character_data(config_file : ConfigFile) -> void:
	# Juno Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.JUNO,
		SeedCharacters._get_juno_character_data()
	)

	# Pettol Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.PETTOL,
		SeedCharacters._get_pettol_character_data()
	)

	# Axo Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.AXO,
		SeedCharacters._get_axo_character_data()
	)

	# Mau Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.MAU,
		SeedCharacters._get_mau_character_data()
	)

	# Eb Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.EB,
		SeedCharacters._get_eb_character_data()
	)

	# Gatz Character Data
	config_file.set_value(
		SeedData.CHARACTERS,
		Character.GATZ,
		SeedCharacters._get_gatz_character_data()
	)

	config_file.save(SeedData.SEED_DATA_CFG_PATH)


#==================
# Helpers
#==================
static func _get_juno_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Juno",
		Character.MACHINE_NAME : Character.JUNO,
		Character.ELEMENT_NAME : Element.NATURE,
		Character.MAX_HP : 10,
		Character.CURRENT_HP : 10,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}

static func _get_pettol_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Pettol",
		Character.MACHINE_NAME : Character.PETTOL,
		Character.ELEMENT_NAME : Element.VOLT,
		Character.MAX_HP : 16,
		Character.CURRENT_HP : 16,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}

static func _get_axo_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Axo",
		Character.MACHINE_NAME : Character.AXO,
		Character.ELEMENT_NAME : Element.WATER,
		Character.MAX_HP : 7,
		Character.CURRENT_HP : 7,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}

static func _get_mau_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Mau",
		Character.MACHINE_NAME : Character.MAU,
		Character.ELEMENT_NAME : Element.FIRE,
		Character.MAX_HP : 12,
		Character.CURRENT_HP : 12,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}

static func _get_eb_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Eb",
		Character.MACHINE_NAME : Character.EB,
		Character.ELEMENT_NAME : Element.ICE,
		Character.MAX_HP : 14,
		Character.CURRENT_HP : 14,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}

static func _get_gatz_character_data() -> Dictionary:
	var current_element_names : Array[String] = []
	var current_status_effects : Array[StatusEffect] = []
	return {
		Character.HUMAN_NAME : "Gatz",
		Character.MACHINE_NAME : Character.GATZ,
		Character.ELEMENT_NAME : Element.AERO,
		Character.MAX_HP : 9,
		Character.CURRENT_HP : 9,
		Character.CURRENT_ELEMENT_NAMES : current_element_names,
		Character.ENTITY_TYPE : BattleConstants.ENTITY_CHARACTER,
		Character.CURRENT_STATUS_EFFECTS : current_status_effects
	}
