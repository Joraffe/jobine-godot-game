extends Resource
class_name Card


var human_name : String
var machine_name : String
var cost : int  # how much it cost to play this card
var element_name : String
var character_name : String
var targeting_name : String
var base_damage : int
var element_amount : int
var combo_trigger_name : String  # name of the combo that gives bonus effects
var combo_bonus_name : String  # name of the bonus effects
var combo_bonus_data : Dictionary  # params for the Combo Bonus


func _init(
	_human_name : String,
	_machine_name : String,
	_cost : int,
	_element_name : String,
	_character_name : String,
	_targeting_name : String,
	_base_damage : int,
	_element_amount : int,
	_combo_trigger_name : String,
	_combo_bonus_name : String,
	_combo_bonus_data : Dictionary
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	cost = _cost
	element_name = _element_name
	character_name = _character_name
	targeting_name = _targeting_name
	base_damage = _base_damage
	element_amount = _element_amount
	combo_trigger_name = _combo_trigger_name
	combo_bonus_name = _combo_bonus_name
	combo_bonus_data = _combo_bonus_data


static func create(card_data : Dictionary) -> Card:
	return Card.new(
		card_data[Card.HUMAN_NAME],
		card_data[Card.MACHINE_NAME],
		card_data[Card.COST],
		card_data[Card.ELEMENT_NAME],
		card_data[Card.CHARACTER_NAME],
		card_data[Card.TARGETING_NAME],
		card_data[Card.BASE_DAMAGE],
		card_data[Card.ELEMENT_AMOUNT],
		card_data[Card.COMBO_TRIGGER_NAME],
		card_data[Card.COMBO_BONUS_NAME],
		card_data[Card.COMBO_BONUS_DATA]
	)

static func create_multi(cards_data : Array[Dictionary]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_data in cards_data:
		cards.append(Card.create(card_data))
	
	return cards

static func by_machine_name(card_machine_name : String) -> Card:
	match card_machine_name:
		Card.PETAL_STORM:
			return PetalStorm()
		Card.BLOOM:
			return Bloom()
		Card.PETTOL_BEAM:
			return PettolBeam()
		Card.CHOMP:
			return Chomp()
		Card.SCALD:
			return Scald()
		Card.SWIFT_SWIM:
			return SwiftSwim()
		_:
			return

static func by_machine_names(card_machine_names : Array[String]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_machine_name in card_machine_names:
		cards.append(Card.by_machine_name(card_machine_name))

	return cards


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const COST : String = "cost"
const ELEMENT_NAME : String = "element_name"
const CHARACTER_NAME : String = "character_name"
const TARGETING_NAME : String = "targeting_name"
const BASE_DAMAGE : String = "base_damage"
const ELEMENT_AMOUNT : String = "element_amount"
const COMBO_TRIGGER_NAME : String = "combo_trigger_name"
const COMBO_BONUS_NAME : String = "combo_bonus_name"
const COMBO_BONUS_DATA : String = "combo_bonus_data"


#=======================
# Juno Cards
#=======================
const PETAL_STORM : String = "petal_storm"
const BLOOM : String = "bloom"

static func PetalStorm() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Petal Storm",
		Card.MACHINE_NAME : Card.PETAL_STORM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.CHARACTER_NAME : Character.JUNO,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.SURGE,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_CARDS,
		Card.COMBO_BONUS_DATA : {ComboBonus.CARD_DRAW_AMOUNT : 1}
	})

static func Bloom() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Bloom",
		Card.MACHINE_NAME : Card.BLOOM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.CHARACTER_NAME : Character.JUNO,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.GROW,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_HEAL,
		Card.COMBO_BONUS_DATA : {ComboBonus.HEAL_AMOUNT : 1}
	})


#=======================
# Pettol Cards
#=======================
const PETTOL_BEAM : String = "pettol_beam"
const CHOMP : String = "chomp"

static func PettolBeam() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Pettol Beam",
		Card.MACHINE_NAME : Card.PETTOL_BEAM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.CHARACTER_NAME : Character.PETTOL,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.CHARGE,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_DAMAGE,
		Card.COMBO_BONUS_DATA : {ComboBonus.DAMAGE : 1}
	})

static func Chomp() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Chomp",
		Card.MACHINE_NAME : Card.CHOMP,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.CHARACTER_NAME : Character.PETTOL,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.SURGE,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_ENERGY,
		Card.COMBO_BONUS_DATA : {ComboBonus.ENERGY_AMOUNT : 1}
	})


#=======================
# Axo Cards
#=======================
const SWIFT_SWIM : String = "swift_swim"
const SCALD : String = "scald"


static func SwiftSwim() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Swift Swim",
		Card.MACHINE_NAME : Card.SWIFT_SWIM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.CHARACTER_NAME : Character.AXO,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.CHARGE,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_STATUS_SELF,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.STATUS_NAME : Status.HASTE,
			ComboBonus.STATUS_DURATION : 1
		}
	})

static func Scald() -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Scald",
		Card.MACHINE_NAME : Card.SCALD,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.CHARACTER_NAME : Character.AXO,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_TRIGGER_NAME : Combo.EVAPORATE,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_STATUS_OTHER,
		Card.COMBO_BONUS_DATA : {
			ComboBonus.STATUS_NAME : Status.VULNERABLE,
			ComboBonus.STATUS_DURATION : 1
		}
	})
