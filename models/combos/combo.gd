extends Resource
class_name Combo


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
		
	}

static func create(combo_data : Dictionary) -> Combo:
	return Combo.new(
		combo_data[HUMAN_NAME],
		combo_data[MACHINE_NAME]
	)

#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
