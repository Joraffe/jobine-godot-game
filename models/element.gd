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

static func Fire() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Fire",
		Element.MACHINE_NAME : Element.FIRE
	})

static func Water() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Water",
		Element.MACHINE_NAME : Element.WATER
	})

static func Nature() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Nature",
		Element.MACHINE_NAME : Element.NATURE
	})

static func Volt() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Volt",
		Element.MACHINE_NAME : Element.VOLT
	})

static func Ice() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Ice",
		Element.MACHINE_NAME : Element.ICE
	})

static func Aero() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "Aero",
		Element.MACHINE_NAME : Element.AERO
	})


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"


#=============================
# Element machine_name list
#=============================
const FIRE : String = "fire"
const WATER : String = "water"
const NATURE : String = "nature"
const VOLT : String = "volt"
const ICE : String = "ice"
const AERO : String = "aero"
