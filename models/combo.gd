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
var status_effect_name : String
var status_effect_duration : int


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
	if self.has_status_effect():
		effects.append(self.get_status_effect(target_instance_id))

	return effects

func has_damage_effect() -> bool:
	return self.base_damage > 0

func has_element_effect() -> bool:
	return self.num_applied_element > 0

func has_status_effect() -> bool:
	return self.status_effect_name != ""

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

func get_status_effect(target_instance_id : int) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : self.get_instance_id(),
		BattleConstants.TARGET_INSTANCE_ID : target_instance_id,
		BattleConstants.EFFECT_TYPE : BattleConstants.STATUS_EFFECT,
		BattleConstants.EFFECT_NAME : self.status_effect_name,
		BattleConstants.EFFECT_AMOUNT : self.status_effect_duration
	}

func has_reaction() -> bool:
	return (
		self.is_evaporate()
		or self.is_burn()
		or self.is_explode()
		or self.is_charge()
		or self.is_chill()
		or self.is_melt()
		or self.is_blaze()
		or self.is_grow()
		or self.is_freeze()
		or self.is_surge()
		or self.is_tempest()
		or self.is_torrent()
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

func is_explode() -> bool:
	return (
		(first_element.is_fire() and second_element.is_volt())
		or
		(first_element.is_volt() and second_element.is_fire())
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

func is_torrent() -> bool:
	return (
		(first_element.is_water() and second_element.is_aero())
		or
		(first_element.is_aero() and second_element.is_water())
	)

func set_empty_derived_data() -> void:
	self.set("human_name", "")
	self.set("machine_name", "")
	self.set("base_damage", 0)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", "")
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_evaporate_derived_data() -> void:
	self.set("human_name", "Evaporate")
	self.set("machine_name", Combo.EVAPORATE)
	self.set("base_damage", 2)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SINGLE)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_burn_derived_data() -> void:
	self.set("human_name", "Burn")
	self.set("machine_name", Combo.BURN)
	self.set("base_damage", 1)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SPLASH)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_explode_derived_data() -> void:
	self.set("human_name", "Explode")
	self.set("machine_name", Combo.EXPLODE)
	self.set("base_damage", 1)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SPLASH)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_charge_derived_data() -> void:
	self.set("human_name", "Charge")
	self.set("machine_name", Combo.CHARGE)
	self.set("base_damage", 0)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SINGLE)
	self.set("status_effect_name", StatusEffect.SHOCK)
	self.set("status_effect_duration", 1)

func set_chill_derived_data() -> void:
	self.set("human_name", "Chill")
	self.set("machine_name", Combo.CHILL)
	self.set("base_damage", 0)
	self.set("applied_element_name", Element.ICE)
	self.set("num_applied_element", 1)
	self.set("targeting_name", Targeting.ALL)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_melt_derived_data() -> void:
	self.set("human_name", "Melt")
	self.set("machine_name", Combo.MELT)
	self.set("base_damage", 2)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SINGLE)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_blaze_derived_data() -> void:
	self.set("human_name", "Blaze")
	self.set("machine_name", Combo.BLAZE)
	self.set("base_damage", 0)
	self.set("applied_element_name", Element.FIRE)
	self.set("num_applied_element", 1)
	self.set("targeting_name", Targeting.ALL)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_grow_derived_data() -> void:
	self.set("human_name", "Grow")
	self.set("machine_name", Combo.GROW)
	self.set("base_damage", 1)
	self.set("applied_element_name", Element.NATURE)
	self.set("num_applied_element", 1)
	self.set("targeting_name", Targeting.SINGLE)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_freeze_derived_data() -> void:
	self.set("human_name", "Freeze")
	self.set("machine_name", Combo.FREEZE)
	self.set("base_damage", 0)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SINGLE)
	self.set("status_effect_name", StatusEffect.FROSTBITE)
	self.set("status_effect_duration", 1)

func set_surge_derived_data() -> void:
	self.set("human_name", "Surge")
	self.set("machine_name", Combo.SURGE)
	self.set("base_damage", 1)
	self.set("applied_element_name", "")
	self.set("num_applied_element", 0)
	self.set("targeting_name", Targeting.SPLASH)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_tempest_derived_data() -> void:
	self.set("human_name", "Tempest")
	self.set("machine_name", Combo.TEMPEST)
	self.set("base_damage", 0)
	self.set("applied_element_name", Element.VOLT)
	self.set("num_applied_element", 1)
	self.set("targeting_name", Targeting.ALL)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_torrent_derived_data() -> void:
	self.set("human_name", "Torrent")
	self.set("machine_name", Combo.TORRENT)
	self.set("base_damage", 0)
	self.set("applied_element_name", Element.WATER)
	self.set("num_applied_element", 1)
	self.set("targeting_name", Targeting.ALL)
	self.set("status_effect_name", "")
	self.set("status_effect_duration", 0)

func set_combo_derived_data() -> void:
	if self.is_evaporate():
		self.set_evaporate_derived_data()
	elif self.is_burn():
		self.set_burn_derived_data()
	elif self.is_explode():
		self.set_explode_derived_data()
	elif self.is_charge():
		self.set_charge_derived_data()
	elif self.is_chill():
		self.set_chill_derived_data()
	elif self.is_melt():
		self.set_melt_derived_data()
	elif self.is_blaze():
		self.set_blaze_derived_data()
	elif self.is_grow():
		self.set_grow_derived_data()
	elif self.is_freeze():
		self.set_freeze_derived_data()
	elif self.is_surge():
		self.set_surge_derived_data()
	elif self.is_tempest():
		self.set_tempest_derived_data()
	elif self.is_torrent():
		self.set_torrent_derived_data()
	else:
		self.set_empty_derived_data()

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
const STATUS_EFFECT_NAME : String = "status_effect_name"


#=============================
# Combo machine_name list
#=============================
const EVAPORATE : String = "evaporate"  # water + fire 
const BURN : String = "burn"  # nature + fire
const EXPLODE : String = "explode"  # fire + volt
const CHARGE : String = "charge"  # volt + water
const CHILL : String = "chill"  # ice + wind
const MELT : String = "melt"  # fire + ice
const BLAZE : String = "blaze"  # fire + wind
const GROW : String = "grow"  # water + nature
const FREEZE : String = "freeze"  # water + ice
const SURGE : String = "surge"  # volt + nature
const TEMPEST : String = "tempest"  # wind + volt
const TORRENT : String = "torrent"  # wind + water


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
