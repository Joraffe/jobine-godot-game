extends Resource
class_name SeedCards


#==================
# Card Data
#==================
static func seed_card_data(config_file : ConfigFile) -> void:
	# Juno Card Data
	config_file.set_value(
		SeedData.CARDS,
		Character.JUNO,
		SeedCards._get_juno_card_data()
	)

	# Pettol Card Data
	config_file.set_value(
		SeedData.CARDS,
		Character.PETTOL,
		SeedCards._get_pettol_card_data()
	)

	# Axo Card Data
	config_file.set_value(
		SeedData.CARDS,
		Character.AXO,
		SeedCards._get_axo_card_data()
	)

	config_file.save(SeedData.SEED_DATA_CFG_PATH)


#==================
# Character Cards
#==================
static func _get_juno_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []
	cards.append(SeedCards.floral_dart_card_data())
	cards.append(SeedCards.floral_dart_card_data())
	cards.append(SeedCards.bloom_card_data())
	return cards

static func _get_pettol_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []
	cards.append(SeedCards.chomp_card_data())
	cards.append(SeedCards.chomp_card_data())
	cards.append(SeedCards.pettol_beam_card_data())
	return cards

static func _get_axo_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []
	cards.append(SeedCards.aqua_shot_card_data())
	cards.append(SeedCards.aqua_shot_card_data())
	cards.append(SeedCards.swift_swim_card_data())
	return cards

static func _get_mau_card_data() -> Array[Dictionary]:
	var cards : Array[Dictionary] = []
	cards.append(Card.AQUA_SHOT)
	cards.append(Card.AQUA_SHOT)
	cards.append(Card.SWIFT_SWIM)
	return cards


#==================
# Individual Cards
#==================

# Juno Cards
static func floral_dart_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Floral Dart",
		Card.MACHINE_NAME : Card.FLORAL_DART,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {}
	}

static func bloom_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Bloom",
		Card.MACHINE_NAME : Card.BLOOM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.WATER,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_ENERGY,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.ENERGY_AMOUNT : 1
		}
	}

# Pettol Cards
static func pettol_beam_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Pettol Beam",
		Card.MACHINE_NAME : Card.PETTOL_BEAM,
		Card.COST : 2,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 3,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.WATER,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_DAMAGE,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.DAMAGE : 2,
			ComboBonus.TARGET_GROUP_NAME : BattleConstants.GROUP_ENEMIES,
			ComboBonus.TARGETING_NAME : Targeting.SINGLE
		}
	}

static func chomp_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Chomp",
		Card.MACHINE_NAME : Card.CHOMP,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {}
	}


# Axo Cards
static func swift_swim_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Swift Swim",
		Card.MACHINE_NAME : Card.SWIFT_SWIM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.VOLT,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_SWAP,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.SWAP_AMOUNT : 1
		}
	}

static func aqua_shot_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Aqua Shot",
		Card.MACHINE_NAME : Card.AQUA_SHOT,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {}
	}


# Mau Cards
static func swipe_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Swipe",
		Card.MACHINE_NAME : Card.SWIPE,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.FIRE,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {}
	}

static func infurno_card_data() -> Dictionary:
	return {
		Card.HUMAN_NAME : "Infurno",
		Card.MACHINE_NAME : Card.INFURNO,
		Card.COST : 2,
		Card.ELEMENT_NAME : Element.FIRE,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 3,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.AERO,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_STATUS,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.STATUS_NAME : StatusEffect.HEAT,
			ComboBonus.STATUS_DURATION : 1,
			ComboBonus.TARGET_GROUP_NAME : BattleConstants.GROUP_PARTY,
			ComboBonus.TARGETING_NAME : Targeting.SINGLE
		}
	}
