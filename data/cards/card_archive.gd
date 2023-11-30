extends Resource
class_name CardArchive


static func get_card(name : String) -> Card:
	match name:
		WATER_SINGLE_CARD:
			return Card.new(
				WATER_SINGLE_CARD,
				1,
				ElementArchive.WATER_ELEMENT,
				TargetingArchive.ENEMIES_SINGLE_TARGETING,
				[TokenArchive.WATER_TOKEN]
			)
		FIRE_SINGLE_CARD:
			return Card.new(
				FIRE_SINGLE_CARD,
				1,
				ElementArchive.FIRE_ELEMENT,
				TargetingArchive.ENEMIES_SINGLE_TARGETING,
				[TokenArchive.FIRE_TOKEN]
			)
		NATURE_SINGLE_CARD:
			return Card.new(
				NATURE_SINGLE_CARD,
				1,
				ElementArchive.NATURE_ELEMENT,
				TargetingArchive.ENEMIES_SINGLE_TARGETING,
				[TokenArchive.NATURE_TOKEN]
			)
		_:
			return Card.new(
				UNKNOWN_CARD,
				0,
				ElementArchive.UNKNOWN_ELEMENT,
				TargetingArchive.UNKNOWN_TARGETING,
				[]
			)


#=======================
#    List of Cards
#=======================
const WATER_SINGLE_CARD : String = "water_single_card"
const FIRE_SINGLE_CARD : String = "fire_single_card"
const NATURE_SINGLE_CARD : String = "nature_single_card"
const UNKNOWN_CARD : String = "unknown_card"
