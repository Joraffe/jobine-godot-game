extends Resource
class_name Character


var human_name : String
var machine_name : String
var element_name : String
var max_hp : int
var current_hp : int
var entity_type : String


func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int,
	_entity_type : String
):
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	max_hp = _max_hp
	current_hp = _current_hp
	entity_type = _entity_type

func as_dict() -> Dictionary:
	return {
		HUMAN_NAME : human_name,
		MACHINE_NAME : machine_name,
		ELEMENT_NAME : element_name,
		MAX_HP : max_hp,
		CURRENT_HP : current_hp,
	}

static func create(character_data : Dictionary) -> Character:
	return Character.new(
		character_data[Character.HUMAN_NAME],
		character_data[Character.MACHINE_NAME],
		character_data[Character.ELEMENT_NAME],
		character_data[Character.MAX_HP],
		character_data[Character.CURRENT_HP],
		character_data[Character.ENTITY_TYPE]
	)


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const ELEMENT_NAME : String = "element_name"
const MAX_HP : String = "max_hp"
const CURRENT_HP : String = "current_hp"
const ENTITY_TYPE : String = "entity_type"
