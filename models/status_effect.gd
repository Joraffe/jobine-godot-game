extends Resource
class_name StatusEffect


var human_name : String
var machine_name : String
var reduces_on_turn_end : bool
var effect_on_remove : bool
var remove_effect_data : Dictionary
var stackable : bool
var duration : int  # in turns
var displays_on_entity : bool


func _init(
	_human_name : String,
	_machine_name : String,
	_reduces_on_turn_end : bool,
	_effect_on_remove : bool,
	_remove_effect_data : Dictionary,
	_stackable : bool,
	_duration : int,
	_displays_on_entity : bool
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	reduces_on_turn_end = _reduces_on_turn_end
	effect_on_remove = _effect_on_remove
	remove_effect_data = _remove_effect_data
	stackable = _stackable
	duration = _duration
	displays_on_entity = _displays_on_entity

func get_reduce_effect(effector_instance_id : int, target_instance_id : int) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : effector_instance_id,
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.REMOVE_STATUS_EFFECT,
		BattleConstants.EFFECT_NAME : self.machine_name,
		BattleConstants.EFFECT_AMOUNT : 1
	}

func has_gain_status_effect_on_remove() -> bool:
	return StatusEffect.GAINED_STATUS_NAME in self.remove_effect_data.keys()

func will_remove_on_turn_end_with_effects() -> bool:
	return (
		self.reduces_on_turn_end
		and self.duration == 1
		and not self.remove_effect_data.is_empty()
	)

func has_remove_effects() -> bool:
	return not self.remove_effect_data.is_empty()

func get_remove_effects(effector_instance_id : int, target_instance_id : int) -> Array[Dictionary]:
	var remove_effects : Array[Dictionary] = []
	if self.has_gain_status_effect_on_remove():
		remove_effects.append({
		BattleConstants.EFFECTOR_INSTANCE_ID : effector_instance_id,
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.STATUS_EFFECT,
		BattleConstants.EFFECT_NAME : self.remove_effect_data[StatusEffect.GAINED_STATUS_NAME],
		BattleConstants.EFFECT_AMOUNT : 1
	})

	return remove_effects

func has_end_turn_animation() -> bool:
	return self.machine_name in StatusEffect.END_TURN_ANIMATIONS

func get_end_turn_animation_name() -> String:
	return StatusEffect.END_TURN_ANIMATION_MAP[self.machine_name]

static func create(status_data : Dictionary) -> StatusEffect:
	return StatusEffect.new(
		status_data[StatusEffect.HUMAN_NAME],
		status_data[StatusEffect.MACHINE_NAME],
		status_data[StatusEffect.REDUCES_ON_TURN_END],
		status_data[StatusEffect.EFFECT_ON_REMOVE],
		status_data[StatusEffect.REMOVE_EFFECT_DATA],
		status_data[StatusEffect.STACKABLE],
		status_data[StatusEffect.DURATION],
		status_data[StatusEffect.DISPLAYS_ON_ENTITY]
	)

static func by_machine_name(status_machine_name : String, status_duration : int) -> StatusEffect:
	match status_machine_name:
		StatusEffect.SHOCK:
			return Shock(status_duration)
		StatusEffect.FROZEN:
			return Frozen()
		StatusEffect.FROZEN_IMMUNE:
			return FrozenImmune()
		StatusEffect.HEAT:
			return Heat()
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
		StatusEffect.DURATION : status_duration,
		StatusEffect.DISPLAYS_ON_ENTITY : false
	})

static func Frozen() -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Frozen",
		StatusEffect.MACHINE_NAME : StatusEffect.FROZEN,
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.EFFECT_ON_REMOVE : true,
		StatusEffect.REMOVE_EFFECT_DATA : {
			StatusEffect.GAINED_STATUS_NAME : StatusEffect.FROZEN_IMMUNE
		},
		StatusEffect.STACKABLE : false,
		StatusEffect.DURATION : 1,
		StatusEffect.DISPLAYS_ON_ENTITY : true
	})

static func FrozenImmune() -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Frozen Immune",
		StatusEffect.MACHINE_NAME : StatusEffect.FROZEN_IMMUNE,
		StatusEffect.REDUCES_ON_TURN_END : true,
		StatusEffect.EFFECT_ON_REMOVE : false,
		StatusEffect.REMOVE_EFFECT_DATA : {},
		StatusEffect.STACKABLE : true,
		StatusEffect.DURATION : 1,
		StatusEffect.DISPLAYS_ON_ENTITY : false
	})

static func Heat() -> StatusEffect:
	return StatusEffect.create({
		StatusEffect.HUMAN_NAME : "Heat",
		StatusEffect.MACHINE_NAME : StatusEffect.HEAT,
		StatusEffect.REDUCES_ON_TURN_END : false,
		StatusEffect.EFFECT_ON_REMOVE : false,
		StatusEffect.REMOVE_EFFECT_DATA : {},
		StatusEffect.STACKABLE : true,
		StatusEffect.DURATION : 1,
		StatusEffect.DISPLAYS_ON_ENTITY : true
	})


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const REDUCES_ON_TURN_END : String = "reduces_on_turn_end"
const EFFECT_ON_REMOVE : String = "effect_on_remove"
const REMOVE_EFFECT_DATA : String = "remove_effect_data"
const STACKABLE : String = "stackable"
const DURATION : String = "duration"
const DISPLAYS_ON_ENTITY : String = "displays_on_entity"

# remove effect data
const GAINED_STATUS_NAME : String = "gained_status_name"


#=============================
# Status machine_name list
#=============================
const SHOCK : String = "shock"  # take +1 dmg mod to volt combos (combo bonus)
const FROZEN : String = "frozen"  # caused by freeze combo
const FROZEN_IMMUNE : String = "frozen_immune"  # cannot be frozen for a duration
const HEAT : String = "heat"  # deal +1 dmg mod to fire combos (combo bonus)


#==========================================
# End Turn related things
#==========================================
const DEFROST_ANIMATION : String = "defrost"

const END_TURN_EFFECTS : Array[String] = [
	StatusEffect.FROZEN
]
const END_TURN_ANIMATIONS : Array[String] = [
	StatusEffect.FROZEN
]
const END_TURN_ANIMATION_MAP : Dictionary = {
	StatusEffect.FROZEN : StatusEffect.DEFROST_ANIMATION
}
