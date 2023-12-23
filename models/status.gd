extends Resource
class_name Status


var human_name : String
var machine_name : String
var duration : int  # in turns


func _init(
	_human_name : String,
	_machine_name : String,
	_duration : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	duration = _duration

static func create(status_data : Dictionary) -> Status:
	return Status.new(
		status_data[Status.HUMAN_NAME],
		status_data[Status.MACHINE_NAME],
		status_data[Status.DURATION]
	)

static func by_machine_name(status_machine_name : String, card_duration : int) -> Status:
	match status_machine_name:
		Status.VULNERABLE:
			return Vulnerable(card_duration)
		Status.HASTE:
			return Haste(card_duration)
		_:
			return

static func Vulnerable(vuln_duration : int) -> Status:
	return Status.create({
		Status.HUMAN_NAME : "Vulnerable",
		Status.MACHINE_NAME : Status.VULNERABLE,
		Status.DURATION : vuln_duration
	})

static func Haste(haste_duration : int) -> Status:
	return Status.create({
		Status.HUMAN_NAME : "Haste",
		Status.MACHINE_NAME : Status.HASTE,
		Status.DURATION : haste_duration
	})

#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const DURATION : String = "duration"


#=============================
# Status machine_name list
#=============================
const VULNERABLE : String = "vulnerable"  # take +1 dmg
const WEAK : String = "weak"  # deal -1 dmg
const HASTE : String = "haste"  # next card cost 1 less energy
const SLOW : String = "slow"  # next card cost 1 more energy
const IMBALANCE : String = "imbalance"  # next combo bonus negated
