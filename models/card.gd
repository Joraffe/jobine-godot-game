extends Resource
class_name Card


var human_name : String
var machine_name : String
var cost : int  # how much it cost to play this card
var element_name : String
var character_instance_id : int
var targeting_name : String
var base_damage : int
var element_amount : int
var combo_element_name : String  # name of the element to form a combo that gives bonus effects
var combo_bonus_name : String  # name of the bonus effects
var combo_bonus_data : Dictionary  # params for the Combo Bonus
var combo_bonus_targeting_name : String

# derived values
var combo_trigger : Combo
var combo_bonus : ComboBonus


func _init(
	_human_name : String,
	_machine_name : String,
	_cost : int,
	_element_name : String,
	_character_instance_id : int,
	_targeting_name : String,
	_base_damage : int,
	_element_amount : int,
	_combo_element_name : String,
	_combo_bonus_name : String,
	_combo_bonus_data : Dictionary,
	_combo_bonus_targeting_name : String
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	cost = _cost
	element_name = _element_name
	character_instance_id = _character_instance_id
	targeting_name = _targeting_name
	base_damage = _base_damage
	element_amount = _element_amount
	combo_element_name = _combo_element_name
	combo_bonus_name = _combo_bonus_name
	combo_bonus_data = _combo_bonus_data
	combo_bonus_targeting_name = _combo_bonus_targeting_name
	set_combo_derived_data()

func set_combo_derived_data() -> void:
	if self.combo_element_name != "":
		combo_trigger = Combo.create({
			Combo.FIRST_ELEMENT : Element.by_machine_name(self.element_name),
			Combo.SECOND_ELEMENT : Element.by_machine_name(self.combo_element_name)
		})
		combo_bonus = ComboBonus.by_machine_name(
			self.combo_bonus_name,
			self.combo_bonus_data
		)

func card_text() -> String:
	var text : String = ""

	if self.element_amount != 0:
		var element = Element.by_machine_name(self.element_name)

		text += "Apply {amount} {element}.\n".format({
			"amount" : self.element_amount,
			"element" : element.human_name
		})

	if self.base_damage != 0:
		text += "Deal {dmg} damage.\n".format({
			"dmg" : self.base_damage
		})

	if self.combo_trigger and self.combo_bonus:
		text += "\n{trigger}:\n".format({
			"trigger" : self.combo_trigger.human_name
		})
		text += "{bonus}".format({
			"bonus" : self.combo_bonus.card_text()
		})

	return text


static func create(card_data : Dictionary) -> Card:
	return Card.new(
		card_data[Card.HUMAN_NAME],
		card_data[Card.MACHINE_NAME],
		card_data[Card.COST],
		card_data[Card.ELEMENT_NAME],
		card_data[Card.CHARACTER_INSTANCE_ID],
		card_data[Card.TARGETING_NAME],
		card_data[Card.BASE_DAMAGE],
		card_data[Card.ELEMENT_AMOUNT],
		card_data[Card.COMBO_ELEMENT_NAME],
		card_data[Card.COMBO_BONUS_NAME],
		card_data[Card.COMBO_BONUS_DATA],
		card_data[Card.COMBO_BONUS_TARGETING_NAME]
	)

static func create_multi(cards_data : Array[Dictionary]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_data in cards_data:
		cards.append(Card.create(card_data))
	
	return cards

static func by_name_and_instance_id(card_machine_name : String, instance_id : int) -> Card:
	match card_machine_name:
		Card.FLORAL_DART:
			return FloralDart(instance_id)
		Card.BLOOM:
			return Bloom(instance_id)
		Card.PETTOL_BEAM:
			return PettolBeam(instance_id)
		Card.CHOMP:
			return Chomp(instance_id)
		Card.AQUA_SHOT:
			return AquaShot(instance_id)
		Card.SWIFT_SWIM:
			return SwiftSwim(instance_id)
		_:
			return

static func by_names_and_instance_ids(cards_data : Array[Dictionary]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_data in cards_data:
		cards.append(
			Card.by_name_and_instance_id(
				card_data[Card.MACHINE_NAME],
				card_data[Card.CHARACTER_INSTANCE_ID]
			)
		)

	return cards


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const COST : String = "cost"
const ELEMENT_NAME : String = "element_name"
const CHARACTER_INSTANCE_ID : String = "character_instance_id"
const TARGETING_NAME : String = "targeting_name"
const BASE_DAMAGE : String = "base_damage"
const ELEMENT_AMOUNT : String = "element_amount"
const COMBO_ELEMENT_NAME : String = "combo_element_name"
const COMBO_BONUS_NAME : String = "combo_bonus_name"
const COMBO_BONUS_DATA : String = "combo_bonus_data"
const COMBO_BONUS_TARGETING_NAME : String = "combo_bonus_targeting_name"


#========================
# Other constants
#========================
const COMBO_TRIGGER : String = "combo_trigger"
const COMBO_BONUS : String = "combo_bonus"

#=======================
# Juno Cards
#=======================
const FLORAL_DART : String = "floral_dart"
const BLOOM : String = "bloom"

static func FloralDart(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Floral Dart",
		Card.MACHINE_NAME : Card.FLORAL_DART,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {},
		Card.COMBO_BONUS_TARGETING_NAME : ""
	})

static func Bloom(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Bloom",
		Card.MACHINE_NAME : Card.BLOOM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.NATURE,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.WATER,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_ENERGY,
		Card.COMBO_BONUS_DATA : {ComboBonus.ENERGY_AMOUNT : 1},
		Card.COMBO_BONUS_TARGETING_NAME : Targeting.SINGLE
	})


#=======================
# Pettol Cards
#=======================
const PETTOL_BEAM : String = "pettol_beam"
const CHOMP : String = "chomp"

static func PettolBeam(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Pettol Beam",
		Card.MACHINE_NAME : Card.PETTOL_BEAM,
		Card.COST : 2,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 3,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.WATER,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_DAMAGE,
		Card.COMBO_BONUS_DATA : {ComboBonus.DAMAGE : 2},
		Card.COMBO_BONUS_TARGETING_NAME : Targeting.SINGLE
	})

static func Chomp(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Chomp",
		Card.MACHINE_NAME : Card.CHOMP,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.VOLT,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {},
		Card.COMBO_BONUS_TARGETING_NAME : ""
	})


#=======================
# Axo Cards
#=======================
const SWIFT_SWIM : String = "swift_swim"
const AQUA_SHOT : String = "aqua_shot"


static func SwiftSwim(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Swift Swim",
		Card.MACHINE_NAME : Card.SWIFT_SWIM,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 1,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : Element.VOLT,
		Card.COMBO_BONUS_NAME : ComboBonus.EXTRA_SWAP,
		Card.COMBO_BONUS_DATA : {ComboBonus.SWAP_AMOUNT : 1},
		Card.COMBO_BONUS_TARGETING_NAME : ""
	})

static func AquaShot(instance_id : int) -> Card:
	return Card.create({
		Card.HUMAN_NAME : "Aqua Shot",
		Card.MACHINE_NAME : Card.AQUA_SHOT,
		Card.COST : 1,
		Card.ELEMENT_NAME : Element.WATER,
		Card.CHARACTER_INSTANCE_ID : instance_id,
		Card.TARGETING_NAME : Targeting.SINGLE,
		Card.BASE_DAMAGE : 2,
		Card.ELEMENT_AMOUNT : 1,
		Card.COMBO_ELEMENT_NAME : "",
		Card.COMBO_BONUS_NAME : "",
		Card.COMBO_BONUS_DATA : {},
		Card.COMBO_BONUS_TARGETING_NAME : Targeting.SINGLE
	})
