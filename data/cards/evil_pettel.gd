extends Resource
class_name EvilPettelCards


const CHARACTER_NAME : String = "evil_pettel"
const REDRAW : String = "redraw"


static func get_starter_cards() -> Array[Dictionary]:
	return [
		{
			"name": REDRAW,
			"character": CHARACTER_NAME
		},
		{
			"name": REDRAW,
			"character": CHARACTER_NAME
		},
		{
			"name": REDRAW,
			"character": CHARACTER_NAME
		}
	]
