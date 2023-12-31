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
	self.set_combo_derived_data()

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
	return self.element_amount > 0

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
		BattleConstants.EFFECT_NAME : self.element_name,
		BattleConstants.EFFECT_AMOUNT : self.element_amount
	}

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
	)

static func create_multi(cards_data : Array[Dictionary]) -> Array[Card]:
	var cards : Array[Card] = []

	for card_data in cards_data:
		cards.append(Card.create(card_data))
	
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


#=======================
# Pettol Cards
#=======================
const PETTOL_BEAM : String = "pettol_beam"
const CHOMP : String = "chomp"


#=======================
# Axo Cards
#=======================
const SWIFT_SWIM : String = "swift_swim"
const AQUA_SHOT : String = "aqua_shot"


#=======================
# Mau Cards
#=======================
const SWIPE : String = "swipe"
const INFURNO : String = "infurno"


#=======================
# Eb Cards
#=======================
const BOARFROST : String = "boarfrost"
const PORCINE_PIERCE : String = "porcine_pierce"


#=======================
# Gatz Cards
#=======================
const LOOSE : String = "loose"
const ZEPHYR : String = "zephyr"
