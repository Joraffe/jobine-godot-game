extends Resource
class_name StatusEffect


var human_name : String
var machine_name : String
var reduces_on_turn_end : bool
var duration : int  # in turns


func _init(
	_human_name : String,
	_machine_name : String,
	_reduces_on_turn_end : bool,
	_duration : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	reduces_on_turn_end = _reduces_on_turn_end
	duration = _duration

static func create(status_data : Dictionary) -> StatusEffect:
	return StatusEffect.new(
		status_data[StatusEffect.HUMAN_NAME],
		status_data[StatusEffect.MACHINE_NAME],
		status_data[StatusEffect.REDUCES_ON_TURN_END],
		status_data[StatusEffect.DURATION]
	)

static func by_machine_name(status_machine_name : String, status_duration : int) -> StatusEffect:
	match status_machine_name:
		StatusEffect.SHOCK:
			return Shock(status_duration)
		StatusEffect.FROSTBITE:
			return Frostbite(status_duration)
		_:
			return

static func Shock(status_duration : int) -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Shock",
		StatusEffect.MACHINE_NAME : "shock",
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.DURATION : status_duration
	})

static func Frostbite(status_duration : int) -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Frostbite",
		StatusEffect.MACHINE_NAME : "frostbite",
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.DURATION : status_duration
	})


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const REDUCES_ON_TURN_END : String = "reduces_on_turn_end"
const DURATION : String = "duration"


#=============================
# Status machine_name list
#=============================
const SHOCK : String = "shock"  # caused by charge combo; volt dmg +1 modifier
const FROSTBITE : String = "frostbite"  # caused by freeze combo; ice dmg + 1 modifier
