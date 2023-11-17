extends Resource
class_name FlatPettelCards


const CHARACTER_NAME : String = "flat_pettel"
const DEFEND : String = "defend"


static func get_starter_cards() -> Array[CardData]:
	return [
		CardData.new(
			CHARACTER_NAME,
			DEFEND
		),
		CardData.new(
			CHARACTER_NAME,
			DEFEND
		),
		CardData.new(
			CHARACTER_NAME,
			DEFEND
		)
	]
