extends Resource
class_name StatusEffect


var human_name : String
var machine_name : String
var reduces_on_turn_end : bool
var effect_on_remove : bool
var remove_effect_data : Dictionary
var stackable : bool
var duration : int  # in turns


func _init(
	_human_name : String,
	_machine_name : String,
	_reduces_on_turn_end : bool,
	_effect_on_remove : bool,
	_remove_effect_data : Dictionary,
	_stackable : bool,
	_duration : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	reduces_on_turn_end = _reduces_on_turn_end
	effect_on_remove = _effect_on_remove
	stackable = _stackable
	duration = _duration

func get_reduce_effect(effector_instance_id : int, target_instance_id : int) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : effector_instance_id,
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.REMOVE_STATUS_EFFECT,
		BattleConstants.EFFECT_NAME : self.machine_name,
		BattleConstants.EFFECT_AMOUNT : 1
	}

static func create(status_data : Dictionary) -> StatusEffect:
	return StatusEffect.new(
		status_data[StatusEffect.HUMAN_NAME],
		status_data[StatusEffect.MACHINE_NAME],
		status_data[StatusEffect.REDUCES_ON_TURN_END],
		status_data[StatusEffect.EFFECT_ON_REMOVE],
		status_data[StatusEffect.REMOVE_EFFECT_DATA],
		status_data[StatusEffect.STACKABLE],
		status_data[StatusEffect.DURATION]
	)

static func by_machine_name(status_machine_name : String, status_duration : int) -> StatusEffect:
	match status_machine_name:
		StatusEffect.SHOCK:
			return Shock(status_duration)
		StatusEffect.FROZEN:
			return Frozen()
		StatusEffect.FROZEN_IMMUNE:
			return FrozenImmune()
		_:
			return

static func Shock(status_duration : int) -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Shock",
		StatusEffect.MACHINE_NAME : StatusEffect.SHOCK,
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.EFFECT_ON_REMOVE : false,
		StatusEffect.REMOVE_EFFECT_DATA : {},
		StatusEffect.STACKABLE : true,
		StatusEffect.DURATION : status_duration
	})

static func Frozen() -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Frozen",
		StatusEffect.MACHINE_NAME : StatusEffect.FROZEN,
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.EFFECT_ON_REMOVE : true,
		StatusEffect.REMOVE_EFFECT_DATA : {
			StatusEffect.REMOVE_EFFECT_STATUS_EFFECT_NAME : ""
		},
		StatusEffect.STACKABLE : false,
		StatusEffect.DURATION : 1
	})

static func FrozenImmune() -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Frozen Immune",
		StatusEffect.MACHINE_NAME : StatusEffect.FROZEN_IMMUNE,
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.EFFECT_ON_REMOVE : false,
		StatusEffect.REMOVE_EFFECT_DATA : {},
		StatusEffect.STACKABLE : true,
		StatusEffect.DURATION : 1
	})


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const REDUCES_ON_TURN_END : String = "reduces_on_turn_end"
const EFFECT_ON_REMOVE : String = "effect_on_remove"
const REMOVE_EFFECT_DATA : String = "remove_effect_data"
const REMOVE_EFFECT_STATUS_EFFECT_NAME : String = "remove_effect_status_effect_name"
const STACKABLE : String = "stackable"
const DURATION : String = "duration"


#=============================
# Status machine_name list
#=============================
const SHOCK : String = "shock"  # caused by charge combo; volt dmg +1 modifier
const FROZEN : String = "frozen"  # caused by freeze combo
const FROZEN_IMMUNE : String = "frozen_immune"  # cannot be frozen for a duration
