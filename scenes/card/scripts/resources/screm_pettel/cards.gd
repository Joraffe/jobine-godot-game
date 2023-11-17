extends Resource
class_name ScremPettelCards


const CHARACTER_NAME : String = "screm_pettel"
const ATTACK : String = "attack"


static func get_starter_cards() -> Array[CardData]:
	return [
		CardData.new(
			CHARACTER_NAME,
			ATTACK
		),
		CardData.new(
			CHARACTER_NAME,
			ATTACK
		),
		CardData.new(
			CHARACTER_NAME,
			ATTACK
		)
	]
