extends Resource
class_name Character


var human_name : String
var machine_name : String
var element_name : String
var max_hp : int
var current_hp : int
var current_element_names : Array[String]
var entity_type : String


func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int,
	_current_element_names : Array[String],
	_entity_type : String
):
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	max_hp = _max_hp
	current_hp = _current_hp
	current_element_names = _current_element_names
	entity_type = _entity_type

func take_damage(damage : int) -> void:
	var old_current_hp : int = self.current_hp
	var remaining_hp : int = old_current_hp - damage
	if remaining_hp < 0:
		remaining_hp = 0
	self.set("current_hp", remaining_hp)

func has_fainted() -> bool:
	return self.current_hp == 0

func add_element_names(element_names_to_add : Array[String]) -> void:
	self.set(
		"current_element_names",
		self.current_element_names + element_names_to_add
	)

func remove_elements_at_indexes(indexes_to_remove : Array[int]) -> void:
	var new_elements : Array[String] = []
	for i in self.current_element_names.size():
		if not i in indexes_to_remove:
			new_elements.append(self.current_element_names[i])
	self.set("current_element_names", new_elements)

static func create(character_data : Dictionary) -> Character:
	return Character.new(
		character_data[Character.HUMAN_NAME],
		character_data[Character.MACHINE_NAME],
		character_data[Character.ELEMENT_NAME],
		character_data[Character.MAX_HP],
		character_data[Character.CURRENT_HP],
		character_data[Character.CURRENT_ELEMENT_NAMES],
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
const CURRENT_ELEMENT_NAMES : String = "current_element_names"
const ENTITY_TYPE : String = "entity_type"


#============================
# Character machine_name list
#============================
const JUNO : String = "juno"
const PETTOL : String = "pettol"
const AXO : String = "axo"

#============================
# Other constants
#============================
const ENTITY_TYPE_CHARACTER : String = "character"
