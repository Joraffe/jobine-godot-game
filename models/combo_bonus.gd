extends Resource
class_name ComboBonus


var machine_name : String

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

# swap related
var swap_amount : int

# - card related (drawing, discarding)
var card_draw_amount : int

# - energy related (i.e. gain energy)
var energy_amount : int


# derived values
var shield_element : Element
var status : Status


func _init(
	_machine_name : String,
	_damage : int,
	_heal_amount : int,
	_shield_strength : int,
	_shield_element_name : String,
	_status_name : String,
	_status_duration : int,
	_swap_amount : int,
	_card_draw_amount : int,
	_energy_amount : int
) -> void:
	machine_name = _machine_name
	damage = _damage
	heal_amount = _heal_amount
	shield_strength = _shield_strength
	shield_element_name = _shield_element_name
	status_name = _status_name
	status_duration = _status_duration
	swap_amount = _swap_amount
	card_draw_amount = _card_draw_amount
	energy_amount = _energy_amount
	set_derived_data()

func set_derived_data() -> void:
	if self.shield_element_name != "":
		shield_element = Element.by_machine_name(self.shield_element_name)
	
	if self.status_name != "":
		status = Status.by_machine_name(self.status_name, self.status_duration)

func is_extra_damage() -> bool:
	return self.machine_name == ComboBonus.EXTRA_DAMAGE

func is_extra_heal() -> bool:
	return self.machine_name == ComboBonus.EXTRA_HEAL

func is_extra_shield() -> bool:
	return self.machine_name == ComboBonus.EXTRA_SHIELD

func is_extra_swap() -> bool:
	return self.machine_name == ComboBonus.EXTRA_SWAP

func is_extra_energy() -> bool:
	return self.machine_name == ComboBonus.EXTRA_ENERGY

func is_extra_cards() -> bool:
	return self.machine_name == ComboBonus.EXTRA_CARDS

func is_extra_status() -> bool:
	return self.machine_name == ComboBonus.EXTRA_STATUS

func is_self_targeting() -> bool:
	return self.machine_name in [
		ComboBonus.EXTRA_HEAL,
		ComboBonus.EXTRA_SHIELD
	]

func is_other_targeting() -> bool:
	return self.machine_name in [
		ComboBonus.EXTRA_DAMAGE,
		ComboBonus.EXTRA_STATUS
	]

func enemy_activation_text() -> String:
	var activation_text : String

	if self.is_extra_damage():
		activation_text = "+ Bonus Damage!"

	if self.is_extra_status():
		activation_text = "+ Bonus Status!"

	return activation_text

func card_text() -> String:
	var bonus_text : String

	if self.is_extra_damage():
		bonus_text = "Deal +{amount} damage.".format({
			"amount" : self.damage
		})
	elif self.is_extra_heal():
		bonus_text = "Heal for {amount}.".format({
			"amount" : self.heal_amount
		})
	elif self.is_extra_shield():
		bonus_text = "Gain {amount} {element} shield.".format({
			"amount" : self.shield_strength,
			"element" : self.shield_element.human_name
		})
	elif self.is_extra_swap():
		bonus_text = "Gain {amount} swap.".format({
			"amount" : self.swap_amount
		})
	elif self.is_extra_energy():
		bonus_text = "Gain {amount} energy.".format({
			"amount" : self.energy_amount,
		})
	elif self.is_extra_cards():
		var plural_text : String
		if self.card_draw_amount > 1:
			plural_text = "s"
		else:
			plural_text = ""
		bonus_text = "Draw {amount} card{plural}.".format({
			"amount" : self.card_draw_amount,
			"plural" : plural_text
		})
	elif self.is_extra_status():
		bonus_text = "Inflict {amount} {status}.".format({
			"amount" : self.status_duration,
			"status" : self.status.human_name
		})
	else:
		bonus_text = ""

	return bonus_text

static func create(combo_bonus_data : Dictionary) -> ComboBonus:
	return ComboBonus.new(
		combo_bonus_data[ComboBonus.MACHINE_NAME],
		combo_bonus_data[ComboBonus.DAMAGE],
		combo_bonus_data[ComboBonus.HEAL_AMOUNT],
		combo_bonus_data[ComboBonus.SHIELD_STRENGTH],
		combo_bonus_data[ComboBonus.SHIELD_ELEMENT_NAME],
		combo_bonus_data[ComboBonus.STATUS_NAME],
		combo_bonus_data[ComboBonus.STATUS_DURATION],
		combo_bonus_data[ComboBonus.SWAP_AMOUNT],
		combo_bonus_data[ComboBonus.CARD_DRAW_AMOUNT],
		combo_bonus_data[ComboBonus.ENERGY_AMOUNT]
	)

static func ExtraDamage(extra_damage : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_DAMAGE,
		ComboBonus.DAMAGE : extra_damage,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraHeal(card_heal_amount : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_HEAL,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : card_heal_amount,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraShield(
	card_shield_strength : int,
	card_shield_element_name : String
) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_SHIELD,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : card_shield_strength,
		ComboBonus.SHIELD_ELEMENT_NAME : card_shield_element_name,
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraSwap(extra_swaps : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_SWAP,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : extra_swaps,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraEnergy(extra_energy : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_ENERGY,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : extra_energy
	})

static func ExtraCards(extra_cards : int) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_CARDS,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : "",
		ComboBonus.STATUS_DURATION : 0,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : extra_cards,
		ComboBonus.ENERGY_AMOUNT : 0
	})

static func ExtraStatus(
	card_status_name : String,
	card_duration : int
) -> ComboBonus:
	return ComboBonus.create({
		ComboBonus.MACHINE_NAME : ComboBonus.EXTRA_STATUS,
		ComboBonus.DAMAGE : 0,
		ComboBonus.HEAL_AMOUNT : 0,
		ComboBonus.SHIELD_STRENGTH : 0,
		ComboBonus.SHIELD_ELEMENT_NAME : "",
		ComboBonus.STATUS_NAME : card_status_name,
		ComboBonus.STATUS_DURATION : card_duration,
		ComboBonus.SWAP_AMOUNT : 0,
		ComboBonus.CARD_DRAW_AMOUNT : 0,
		ComboBonus.ENERGY_AMOUNT : 0
	})


static func by_machine_name(bonus_machine_name : String, bonus_data : Dictionary) -> ComboBonus:
	match bonus_machine_name:
		ComboBonus.EXTRA_DAMAGE:
			return ExtraDamage(
				bonus_data[ComboBonus.DAMAGE]
			)
		ComboBonus.EXTRA_HEAL:
			return ExtraHeal(
				bonus_data[ComboBonus.HEAL_AMOUNT]
			)
		ComboBonus.EXTRA_SHIELD:
			return ExtraShield(
				bonus_data[ComboBonus.SHIELD_STRENGTH],
				bonus_data[ComboBonus.SHIELD_ELEMENT_NAME]
			)
		ComboBonus.EXTRA_SWAP:
			return ExtraSwap(bonus_data[ComboBonus.SWAP_AMOUNT])
		ComboBonus.EXTRA_ENERGY:
			return ExtraEnergy(bonus_data[ComboBonus.ENERGY_AMOUNT])
		ComboBonus.EXTRA_CARDS:
			return ExtraCards(bonus_data[ComboBonus.CARD_DRAW_AMOUNT])
		ComboBonus.EXTRA_STATUS:
			return ExtraStatus(
				bonus_data[ComboBonus.STATUS_NAME],
				bonus_data[ComboBonus.STATUS_DURATION],
			)
		_:
			return


#========================
# Init Param kwarg names
#========================
const MACHINE_NAME : String = "machine_name"
const TYPE : String = "type"
const DAMAGE : String = "damage"
const HEAL_AMOUNT : String = "heal_amount"
const SHIELD_STRENGTH : String = "shield_strength"
const SHIELD_ELEMENT_NAME : String = "shield_element_name"
const STATUS_NAME : String = "status_name"
const STATUS_DURATION : String = "status_duration"
const SWAP_AMOUNT : String = "swap_amount"
const CARD_DRAW_AMOUNT : String = "card_draw_amount"
const ENERGY_AMOUNT : String = "energy_amount"


#=========================
# Bonus machine_name list
#=========================
const EXTRA_DAMAGE : String = "extra_damage"
const EXTRA_SWAP : String = "extra_swap"
const EXTRA_HEAL : String = "extra_heal"
const EXTRA_SHIELD : String = "extra_shield"
const EXTRA_ENERGY : String = "extra_energy"
const EXTRA_CARDS : String = "extra_cards"
const EXTRA_STATUS : String = "extra_status"


#=============================
# ComboBonus signal constants
#=============================
const ENTITY_NAME : String = "entity_name"
const COMBO_TRIGGER : String = "combo_trigger"
const COMBO_BONUS : String = "combo_bonus"
const TARGETING : String = "targeting"
