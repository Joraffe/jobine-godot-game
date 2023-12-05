extends Resource
class_name Card


var human_name : String
var machine_name : String
var cost : int  # how much it cost to play this card
var element_name : String
var character_name : String
var targeting_name : String
var effect_count : int  # how many times to apply card effect


func _init(
	_human_name : String,
	_machine_name : String,
	_cost : int,
	_element_name : String,
	_character_name : String,
	_targeting_name : String,
	_effect_count : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	cost = _cost
	element_name = _element_name
	character_name = _character_name
	targeting_name = _targeting_name
	effect_count = _effect_count

func as_dict() -> Dictionary:
	return {
		HUMAN_NAME : human_name,
		MACHINE_NAME : machine_name,
		COST : cost,
		ELEMENT_NAME : element_name,
		CHARACTER_NAME : character_name,
		TARGETING_NAME : targeting_name,
		EFFECT_COUNT : effect_count
	}

static func create(card_data : Dictionary) -> Card:
	return Card.new(
		card_data[HUMAN_NAME],
		card_data[MACHINE_NAME],
		card_data[COST],
		card_data[ELEMENT_NAME],
		card_data[CHARACTER_NAME],
		card_data[TARGETING_NAME],
		card_data[EFFECT_COUNT]
	)

static func create_multi(cards_data : Array[Dictionary]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_data in cards_data:
		cards.append(Card.create(card_data))
	
	return cards


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const COST : String = "cost"
const ELEMENT_NAME : String = "element_name"
const CHARACTER_NAME : String = "character_name"
const TARGETING_NAME : String = "targeting_name"
const EFFECT_COUNT : String = "effect_count"
