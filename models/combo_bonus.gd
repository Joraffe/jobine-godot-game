extends Resource
class_name ComboBonus


var machine_name : String

var receiver_name : String  # self or other

# extra damage
var damage : int

# heal character
var heal_amount : int

# provide a shield (extra hp/combo to break)
var shield_strength : int
var shield_element_name : String

# - apply status effect to enemy
# - apply status effect to self
var status_name : String  # if this bonus applies
var status_duration : int

# - card related (drawing, discarding)
var card_draw_amount : int

# - energy related (i.e. gain energy)
var energy_amount : int


func _init(
	_machine_name : String,
	_receiver_name : String,
	_damage : int,
	_heal_amount : int,
	_shield_strength : int,
	_shield_element_name : String,
	_status_name : String,
	_status_duration : int,

	_card_draw_amount : int,
	_energy_amount : int
) -> void:
	machine_name = _machine_name
	receiver_name = _receiver_name
	damage = _damage
	heal_amount = _heal_amount
	shield_strength = _shield_strength
	shield_element_name = _shield_element_name
	status_name = _status_name
	status_duration = _status_duration

	card_draw_amount = _card_draw_amount
	energy_amount = _energy_amount

static func create(combo_bonus_data : Dictionary) -> ComboBonus:
	return ComboBonus.new(
		combo_bonus_data[ComboBonus.MACHINE_NAME],
		combo_bonus_data[ComboBonus.RECEIVER_NAME],
		combo_bonus_data[ComboBonus.DAMAGE],
		combo_bonus_data[ComboBonus.HEAL_AMOUNT],
		combo_bonus_data[ComboBonus.SHIELD_STRENGTH],
		combo_bonus_data[ComboBonus.SHIELD_ELEMENT_NAME],
		combo_bonus_data[ComboBonus.STATUS_NAME],
		combo_bonus_data[ComboBonus.STATUS_DURATION],
		combo_bonus_data[ComboBonus.CARD_DRAW_AMOUNT],
		combo_bonus_data[ComboBonus.ENERGY_AMOUNT]
	)

static func ExtraDamage(extra_damage : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_DAMAGE,
		ComboBonus.RECEIVER_NAME : ComboBonus.OTHER,
		ComboBonus.DAMAGE : extra_damage,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraHeal(card_heal_amount : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_HEAL,
		ComboBonus.RECEIVER_NAME : ComboBonus.SELF,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : card_heal_amount,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraShield(card_shield_strength : int, card_shield_element_name : String) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_SHIELD,
		ComboBonus.RECEIVER_NAME : ComboBonus.SELF,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : card_shield_strength,
		ComboBonus.SHIELD_ELEMENT_NAME : card_shield_element_name,
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraEnergy(extra_energy : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_ENERGY,
		ComboBonus.RECEIVER_NAME : ComboBonus.SELF,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : extra_energy
	})

static func ExtraCards(extra_cards : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_CARDS,
		ComboBonus.RECEIVER_NAME : ComboBonus.SELF,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.CARD_DRAW_AMOUNT : extra_cards,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraStatusOther(card_status_name : String, card_duration : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_STATUS_OTHER,
		ComboBonus.RECEIVER_NAME : ComboBonus.OTHER,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : card_status_name,
		ComboBonus.STATUS_DURATION : card_duration,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraStatusSelf(card_status_name : String, card_duration : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_STATUS_SELF,
		ComboBonus.RECEIVER_NAME : ComboBonus.SELF,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : card_status_name,
		ComboBonus.STATUS_DURATION : card_duration,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})


#========================
# Init Param kwarg names
#========================
const MACHINE_NAME : String = "machine_name"
const RECEIVER_NAME : String = "receiver_name"
const TYPE : String = "type"
const DAMAGE : String = "damage"
const HEAL_AMOUNT : String = "heal_amount"
const SHIELD_STRENGTH : String = "shield_strength"
const SHIELD_ELEMENT_NAME : String = "shield_element_name"
const STATUS_NAME : String = "status_name"
const STATUS_DURATION : String = "status_duration"
const CARD_DRAW_AMOUNT : String = "card_draw_amount"
const ENERGY_AMOUNT : String = "energy_amount"


#=========================
# Bonus machine_name list
#=========================
const EXTRA_DAMAGE : String = "extra_damage"
const EXTRA_HEAL : String = "extra_heal"
const EXTRA_SHIELD : String = "extra_shield"
const EXTRA_ENERGY : String = "extra_energy"
const EXTRA_CARDS : String = "extra_cards"
const EXTRA_STATUS_OTHER : String = "extra_status_other"
const EXTRA_STATUS_SELF : String = "extra_status_self"


#========================
# Other constants
#========================
const SELF : String = "self"
const OTHER : String = "other"
