extends Resource
class_name Combo


var first_element : Element
var second_element : Element

# derived from first_element + second_element
var human_name : String
var machine_name : String
var base_damage : int
var applied_element_name : String
var num_applied_element : int
var targeting_name : String


func _init(
	_first_element : Element,
	_second_element : Element,
) -> void:
	first_element = _first_element
	second_element = _second_element
	# based off of first_element + second_element
	set_combo_derived_data()

func get_sequential_effects(target_instance_id : int) -> Array[Dictionary]:
	var effects : Array[Dictionary] = []

	if self.has_damage_effect():
		effects.append(self.get_damage_effect(target_instance_id))
	if self.has_element_effect():
		effects.append(self.get_element_effect(target_instance_id))

	return effects

func has_damage_effect() -> bool:
	return self.base_damage > 0

func has_element_effect() -> bool:
	return self.num_applied_element > 0

func get_damage_effect(target_instance_id : int) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : self.get_instance_id(),
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.DAMAGE_EFFECT,
		BattleConstants.EFFECT_AMOUNT : self.base_damage,
	}

func get_element_effect(target_instance_id : int) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : self.get_instance_id(),
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.ELEMENT_EFFECT,
		BattleConstants.EFFECT_NAME : self.applied_element_name,
		BattleConstants.EFFECT_AMOUNT : self.num_applied_element
	}

func has_reaction() -> bool:
	return (
		self.is_evaporate()
		or self.is_burn()
		or self.is_charge()
		or self.is_chill()
		or self.is_melt()
		or self.is_blaze()
		or self.is_grow()
		or self.is_freeze()
		or self.is_surge()
		or self.is_tempest()
	)

func is_evaporate() -> bool:
	return (
		(first_element.is_fire() and second_element.is_water())
		or
		(first_element.is_water() and second_element.is_fire())
	)

func is_burn() -> bool:
	return (
		(first_element.is_fire() and second_element.is_nature())
		or
		(first_element.is_nature() and second_element.is_fire())
	)

func is_charge() -> bool:
	return (
		(first_element.is_volt() and second_element.is_water())
		or
		(first_element.is_water() and second_element.is_volt())
	)

func is_chill() -> bool:
	return (
		(first_element.is_aero() and second_element.is_ice())
		or
		(first_element.is_ice() and second_element.is_aero())
	)

func is_melt() -> bool:
	return (
		(first_element.is_fire() and second_element.is_ice())
		or
		(first_element.is_ice() and second_element.is_fire())
	)

func is_blaze() -> bool:
	return (
		(first_element.is_fire() and second_element.is_aero())
		or
		(first_element.is_aero() and second_element.is_fire())
	)

func is_grow() -> bool:
	return (
		(first_element.is_nature() and second_element.is_water())
		or
		(first_element.is_water() and second_element.is_nature())
	)

func is_freeze() -> bool:
	return (
		(first_element.is_ice() and second_element.is_water())
		or
		(first_element.is_water() and second_element.is_ice())
	)

func is_surge() -> bool:
	return (
		(first_element.is_volt() and second_element.is_nature())
		or
		(first_element.is_nature() and second_element.is_volt())
	)

func is_tempest() -> bool:
	return (
		(first_element.is_volt() and second_element.is_aero())
		or
		(first_element.is_aero() and second_element.is_volt())
	)

func set_combo_derived_data() -> void:
	if is_evaporate():
		human_name = "Evaporate"
		machine_name = Combo.EVAPORATE
		base_damage = 2
		applied_element_name = ""
		num_applied_element = 0
		targeting_name = Targeting.SINGLE
	elif is_burn():
		human_name = "Burn"
		machine_name = Combo.BURN
		base_damage = 1
		applied_element_name = ""
		num_applied_element = 0
		targeting_name = Targeting.SPLASH
	elif is_charge():
		human_name = "Charge"
		machine_name = Combo.CHARGE
		base_damage = 0
		applied_element_name = Element.VOLT
		num_applied_element = 2
		targeting_name = Targeting.SINGLE
	elif is_chill():
		human_name = "Chill"
		machine_name = Combo.CHILL
		base_damage = 0
		applied_element_name = Element.ICE
		num_applied_element = 1
		targeting_name = Targeting.ALL
	elif is_melt():
		human_name = "Melt"
		machine_name = Combo.MELT
		base_damage = 2
		applied_element_name = ""
		num_applied_element = 0
		targeting_name = Targeting.SINGLE
	elif is_blaze():
		human_name = "Blaze"
		machine_name = Combo.BLAZE
		base_damage = 0
		applied_element_name = Element.FIRE
		num_applied_element = 1
		targeting_name = Targeting.ALL
	elif is_grow():
		human_name = "Grow"
		machine_name = Combo.GROW
		base_damage = 1
		applied_element_name = Element.NATURE
		num_applied_element = 1
		targeting_name = Targeting.SINGLE
	elif is_freeze():
		human_name = "Freeze"
		machine_name = Combo.FREEZE
		base_damage = 0
		applied_element_name = Element.ICE
		num_applied_element = 2
		targeting_name = Targeting.SINGLE
	elif is_surge():
		human_name = "Surge"
		machine_name = Combo.SURGE
		base_damage = 1
		applied_element_name = ""
		num_applied_element = 0
		targeting_name = Targeting.SPLASH
	elif is_tempest():
		human_name = "Tempest"
		machine_name = Combo.TEMPEST
		base_damage = 0
		applied_element_name = Element.VOLT
		num_applied_element = 1
		targeting_name = Targeting.ALL
	else:
		human_name = ""
		machine_name = ""
		base_damage = 0
		applied_element_name = ""
		num_applied_element = 0
		targeting_name = ""

static func create(combo_data : Dictionary) -> Combo:
	return Combo.new(
		combo_data[Combo.FIRST_ELEMENT],
		combo_data[Combo.SECOND_ELEMENT],
	)

static func Empty() -> Combo:
	return Combo.new(Element.Empty(), Element.Empty())

#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const BASE_DAMAGE : String = "base_damage"
const APPLIED_ELEMENT_NAME : String = "applied_element_name"
const NUM_APPLIED_ELEMENT : String = "num_applied_element"
const TARGETING_NAME : String = "targeting_name"


#=============================
# Combo machine_name list
#=============================
const EVAPORATE : String = "evaporate"  # water + fire 
const BURN : String = "burn"  # nature + fire
const CHARGE : String = "charge"  # volt + water
const CHILL : String = "chill"  # ice + wind
const MELT : String = "melt"  # fire + ice
const BLAZE : String = "blaze"  # fire + wind
const GROW : String = "grow"  # water + nature
const FREEZE : String = "freeze"  # water + ice
const SURGE : String = "surge"  # volt + nature
const TEMPEST : String = "tempest"  # wind + volt


#========================
# Combo Signal constants
#========================
const FIRST_ELEMENT_INDEX : String = "first_element_index"
const FIRST_ELEMENT_NAME : String = "first_element_name"
const SECOND_ELEMENT_INDEX : String = "second_element_index"
const SECOND_ELEMENT_NAME : String = "second_element_name"
const FIRST_ELEMENT : String = "first_element"
const SECOND_ELEMENT : String = "second_element"
const COMBO : String = "combo"
const INDEX : String = "index"
const ELEMENT : String = "element"
const ENTITY : String = "entity"
const ENTITY_ID : String = "entity_id"
