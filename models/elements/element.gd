extends Resource
class_name Element


var human_name : String
var machine_name : String


func _init(
	_human_name : String,
	_machine_name : String
	) -> void:
	human_name = _human_name
	machine_name = _machine_name

func as_dict() -> Dictionary:
	return {
		HUMAN_NAME : human_name,
		MACHINE_NAME : machine_name
	}

static func create(element_data : Dictionary) -> Element:
	return Element.new(
		element_data[HUMAN_NAME],
		element_data[MACHINE_NAME]
	)

#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
