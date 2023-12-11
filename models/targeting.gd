extends Resource
class_name Targeting


var human_name : String
var machine_name : String
var primary_target_name : String


func _init(
	_human_name : String,
	_machine_name : String,
	_primary_target_name : String
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	primary_target_name = _primary_target_name

func is_single_targeting() -> bool:
	return self.machine_name == Targeting.SINGLE

func is_blast_targeting() -> bool:
	return self.machine_name == Targeting.BLAST

func is_all_targeting() -> bool:
	return self.machine_name == Targeting.ALL

static func create(targeting_data : Dictionary) -> Targeting:
	return Targeting.new(
		targeting_data[Targeting.HUMAN_NAME],
		targeting_data[Targeting.MACHINE_NAME],
		targeting_data[Targeting.PRIMARY_TARGET_NAME]
	)

static func Single(target_name : String) -> Targeting:
	return Targeting.create({
		Targeting.HUMAN_NAME : "Single",
		Targeting.MACHINE_NAME : Targeting.SINGLE,
		Targeting.PRIMARY_TARGET_NAME : target_name
	})

static func Blast(target_name : String) -> Targeting:
	return Targeting.create({
		Targeting.HUMAN_NAME : "Blast",
		Targeting.MACHINE_NAME : Targeting.BLAST,
		Targeting.PRIMARY_TARGET_NAME : target_name
	})

static func All() -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "All",
		MACHINE_NAME : Targeting.ALL,
		Targeting.PRIMARY_TARGET_NAME : ""
	})

static func by_machine_name(targeting_machine_name : String, target_name : String) -> Targeting:
	match targeting_machine_name:
		Targeting.SINGLE:
			return Targeting.Single(target_name)
		Targeting.BLAST:
			return Targeting.Blast(target_name)
		Targeting.ALL:
			return Targeting.All()
		_:
			return null


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const PRIMARY_TARGET_NAME : String = "primary_target_name"


#=============================
# Targeting machine_name list
#=============================
const SINGLE : String = "single_targeting"
const BLAST : String = "blast_targeting"
const ALL : String = "all_targeting"
