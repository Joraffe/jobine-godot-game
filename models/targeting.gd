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

func is_splash_targeting() -> bool:
	return self.machine_name == Targeting.SPLASH

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

static func Splash(instance_id : int) -> Targeting:
	return Targeting.create({
		Targeting.HUMAN_NAME : "Splash",
		Targeting.MACHINE_NAME : Targeting.SPLASH,
		Targeting.PRIMARY_TARGET_INSTANCE_ID : instance_id
	})

static func All(instance_id : int) -> Targeting:
	return Targeting.create({
		HUMAN_NAME : "All",
		MACHINE_NAME : Targeting.ALL,
		Targeting.PRIMARY_TARGET_INSTANCE_ID : instance_id
	})

static func by_machine_name(targeting_machine_name : String, instance_id : int) -> Targeting:
	match targeting_machine_name:
		Targeting.SINGLE:
			return Targeting.Single(instance_id)
		Targeting.BLAST:
			return Targeting.Blast(instance_id)
		Targeting.SPLASH:
			return Targeting.Splash(instance_id)
		Targeting.ALL:
			return Targeting.All(instance_id)
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
const SINGLE : String = "single"
const BLAST : String = "blast"
const SPLASH : String = "splash"
const ALL : String = "all"
