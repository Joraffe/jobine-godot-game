extends Resource
class_name FlatPettelCards


const CHARACTER_NAME : String = "flat_pettel"
const DEFEND : String = "defend"


static func get_starter_cards() -> Array[Dictionary]:
	return [
		{
			"name": DEFEND,
			"character": CHARACTER_NAME
		},
		{
			"name": DEFEND,
			"character": CHARACTER_NAME
		},
		{
			"name": DEFEND,
			"character": CHARACTER_NAME
		},
	]
