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

func is_fire() -> bool:
	return self.machine_name == Element.FIRE

func is_water() -> bool:
	return self.machine_name == Element.WATER

func is_nature() -> bool:
	return self.machine_name == Element.NATURE

func is_volt() -> bool:
	return self.machine_name == Element.VOLT

func is_ice() -> bool:
	return self.machine_name == Element.ICE

func is_aero() -> bool:
	return self.machine_name == Element.AERO

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

static func Empty() -> Element:
	return Element.create({
		Element.HUMAN_NAME : "",
		Element.MACHINE_NAME : ""
	})

static func by_machine_name(_machine_name : String) -> Element:
	match _machine_name:
		Element.FIRE:
			return Fire()
		Element.WATER:
			return Water()
		Element.NATURE:
			return Nature()
		Element.VOLT:
			return Volt()
		Element.ICE:
			return Ice()
		Element.AERO:
			return Aero()
		_:
			return Empty()

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
