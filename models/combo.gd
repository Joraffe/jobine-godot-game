extends Resource
class_name Combo


var human_name : String
var machine_name : String
var base_damage : int
var applied_element_name : String
var num_applied_element : int
var targeting_name : String


func _init(
	_human_name : String,
	_machine_name : String,
	_base_damage : int,
	_applied_element_name : String,
	_num_applied_element : int,
	_targeting_name : String
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	base_damage = _base_damage
	applied_element_name = _applied_element_name
	num_applied_element = _num_applied_element
	targeting_name = _targeting_name


static func create(combo_data : Dictionary) -> Combo:
	return Combo.new(
		combo_data[Combo.HUMAN_NAME],
		combo_data[Combo.MACHINE_NAME],
		combo_data[Combo.BASE_DAMAGE],
		combo_data[Combo.APPLIED_ELEMENT_NAME],
		combo_data[Combo.NUM_APPLIED_ELEMENT],
		combo_data[Combo.TARGETING_NAME]
	)

static func Evaporate() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Evaporate",
		Combo.MACHINE_NAME : Combo.EVAPORATE,
		Combo.BASE_DAMAGE : 2,
		Combo.APPLIED_ELEMENT_NAME : "",
		Combo.NUM_APPLIED_ELEMENT : 0,
		Combo.TARGETING_NAME : Targeting.SINGLE
	})

static func Burn() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Burn",
		Combo.MACHINE_NAME : Combo.BURN,
		Combo.BASE_DAMAGE : 1,
		Combo.APPLIED_ELEMENT_NAME : "",
		Combo.NUM_APPLIED_ELEMENT : 0,
		Combo.TARGETING_NAME : Targeting.BLAST
	})

static func Charge() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Charge",
		Combo.MACHINE_NAME : Combo.CHARGE,
		Combo.BASE_DAMAGE : 1,
		Combo.APPLIED_ELEMENT_NAME : Element.VOLT,
		Combo.NUM_APPLIED_ELEMENT : 2,
		Combo.TARGETING_NAME : Targeting.SINGLE
	})

static func Chill() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Chill",
		Combo.MACHINE_NAME : Combo.CHILL,
		Combo.BASE_DAMAGE : 0,
		Combo.APPLIED_ELEMENT_NAME : Element.ICE,
		Combo.NUM_APPLIED_ELEMENT : 1,
		Combo.TARGETING_NAME : Targeting.ALL
	})

static func Melt() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Melt",
		Combo.MACHINE_NAME : Combo.MELT,
		Combo.BASE_DAMAGE : 2,
		Combo.APPLIED_ELEMENT_NAME : "",
		Combo.NUM_APPLIED_ELEMENT : 0,
		Combo.TARGETING_NAME : Targeting.SINGLE
	})

static func Blaze() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Blaze",
		Combo.MACHINE_NAME : Combo.BLAZE,
		Combo.BASE_DAMAGE : 0,
		Combo.APPLIED_ELEMENT_NAME : Element.FIRE,
		Combo.NUM_APPLIED_ELEMENT : 1,
		Combo.TARGETING_NAME : Targeting.Blast
	})

static func Grow() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Grow",
		Combo.MACHINE_NAME : Combo.GROW,
		Combo.BASE_DAMAGE : 1,
		Combo.APPLIED_ELEMENT_NAME : Element.NATURE,
		Combo.NUM_APPLIED_ELEMENT : 1,
		Combo.TARGETING_NAME : Targeting.SINGLE
	})

static func Freeze() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Freeze",
		Combo.MACHINE_NAME : Combo.FREEZE,
		Combo.BASE_DAMAGE : 0,
		Combo.APPLIED_ELEMENT_NAME : Element.ICE,
		Combo.NUM_APPLIED_ELEMENT : 2,
		Combo.TARGETING_NAME : Targeting.SINGLE
	})

static func Surge() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Surge",
		Combo.MACHINE_NAME : Combo.SURGE,
		Combo.BASE_DAMAGE : 1,
		Combo.APPLIED_ELEMENT_NAME : "",
		Combo.NUM_APPLIED_ELEMENT : 0,
		Combo.TARGETING_NAME : Targeting.BLAST
	})

static func Tempest() -> Combo:
	return Combo.create({
		Combo.HUMAN_NAME : "Tempest",
		Combo.MACHINE_NAME : Combo.TEMPEST,
		Combo.BASE_DAMAGE : 0,
		Combo.APPLIED_ELEMENT_NAME : Element.VOLT,
		Combo.NUM_APPLIED_ELEMENT : 1,
		Combo.TARGETING_NAME : Targeting.ALL
	})

static func by_machine_name(_machine_name : String) -> Combo:
	match _machine_name:
		Combo.EVAPORATE:
			return Combo.Evaporate()
		Combo.BURN:
			return Combo.Burn()
		Combo.CHARGE:
			return Combo.Charge()
		Combo.CHILL:
			return Combo.Chill()
		Combo.MELT:
			return Combo.Melt()
		Combo.BLAZE:
			return Combo.Blaze()
		Combo.GROW:
			return Combo.Grow()
		Combo.FREEZE:
			return Combo.Freeze()
		Combo.SURGE:
			return Combo.Surge()
		Combo.TEMPEST:
			return Combo.Tempest()
		_:
			return null


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

const FIRST_ELEMENT : String = "first_element"
const SECOND_ELEMENT : String = "second_element"
const COMBO : String = "combo"
const INDEX : String = "index"
const ELEMENT : String = "element"
const ENTITY : String = "entity"
