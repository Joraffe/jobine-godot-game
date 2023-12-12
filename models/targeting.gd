extends Resource
class_name Targeting


var human_name : String
var machine_name : String
var primary_target_instance_id : int


func _init(
	_human_name : String,
	_machine_name : String,
	_primary_target_instance_id : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	primary_target_instance_id = _primary_target_instance_id

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
		targeting_data[Targeting.PRIMARY_TARGET_INSTANCE_ID]
	)

static func Single(instance_id : int) -> Targeting:
	return Targeting.create({
		Targeting.HUMAN_NAME : "Single",
		Targeting.MACHINE_NAME : Targeting.SINGLE,
		Targeting.PRIMARY_TARGET_INSTANCE_ID : instance_id
	})

static func Blast(instance_id : int) -> Targeting:
	return Targeting.create({
		Targeting.HUMAN_NAME : "Blast",
		Targeting.MACHINE_NAME : Targeting.BLAST,
		Targeting.PRIMARY_TARGET_INSTANCE_ID : instance_id
	})

static func All() -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "All",
		MACHINE_NAME : Targeting.ALL,
		Targeting.PRIMARY_TARGET_INSTANCE_ID : null
	})

static func by_machine_name(targeting_machine_name : String, instance_id : int) -> Targeting:
	match targeting_machine_name:
		Targeting.SINGLE:
			return Targeting.Single(instance_id)
		Targeting.BLAST:
			return Targeting.Blast(instance_id)
		Targeting.ALL:
			return Targeting.All()
		_:
			return null


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const PRIMARY_TARGET_INSTANCE_ID : String = "primary_target_instance_id"


#=============================
# Targeting machine_name list
#=============================
const SINGLE : String = "single_targeting"
const BLAST : String = "blast_targeting"
const ALL : String = "all_targeting"
