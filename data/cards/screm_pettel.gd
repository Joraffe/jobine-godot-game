extends Resource
class_name ScremPettelCards


const CHARACTER_NAME : String = "screm_pettel"
const ATTACK : String = "attack"


static func get_starter_cards() -> Array[Dictionary]:
	return [
		{
			"name": ATTACK,
			"character": CHARACTER_NAME
		},
		{
			"name": ATTACK,
			"character": CHARACTER_NAME
		},
		{
			"name": ATTACK,
			"character": CHARACTER_NAME
		}
	]
