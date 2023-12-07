extends Resource
class_name Targeting


var human_name : String
var machine_name : String


func _init(
	_human_name : String,
	_machine_name : String,
) -> void:
	human_name = _human_name
	machine_name = _machine_name

static func create(targeting_data : Dictionary) -> Targeting:
	return Targeting.new(
		targeting_data[HUMAN_NAME],
		targeting_data[MACHINE_NAME]
	)

static func Single() -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "Single",
		MACHINE_NAME : Targeting.SINGLE
	})

static func Blast() -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "Blast",
		MACHINE_NAME : Targeting.BLAST
	})

static func All() -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "All",
		MACHINE_NAME : Targeting.ALL
	})

static func by_machine_name(_machine_name : String) -> Targeting:
	match _machine_name:
		Targeting.SINGLE:
			return Targeting.Single()
		Targeting.BLAST:
			return Targeting.Blast()
		Targeting.ALL:
			return Targeting.All()
		_:
			return null


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"


#=============================
# Targeting machine_name list
#=============================
const SINGLE : String = "single_targeting"
const BLAST : String = "blast_targeting"
const ALL : String = "all_targeting"
