extends Resource
class_name EvilPettelCards


const CHARACTER_NAME : String = "evil_pettel"
const REDRAW : String = "redraw"


static func get_starter_cards() -> Array[CardData]:
	return [
		CardData.new(
			CHARACTER_NAME,
			REDRAW
		),
		CardData.new(
			CHARACTER_NAME,
			REDRAW
		),
		CardData.new(
			CHARACTER_NAME,
			REDRAW
		)
	]
