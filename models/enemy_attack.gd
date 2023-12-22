extends Resource
class_name EnemyAttack


var human_name : String
var machine_name : String

var element_name : String
var num_applied_element : int

var status_name : String
var status_duration : int

var status_card_name : String
var num_status_cards : int

var base_damage : int

var enemy_instance_id : int


func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_num_applied_element : int,
	_status_name : String,
	_status_duration : int,
	_status_card_name : String,
	_num_status_cards : int,
	_base_damage : int,
	_enemy_instance_id : int
) -> void:
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	num_applied_element = _num_applied_element
	status_name = _status_name
	status_duration = _status_duration
	status_card_name = _status_card_name
	num_status_cards = _num_status_cards
	base_damage = _base_damage
	enemy_instance_id = _enemy_instance_id

func deals_damage() -> bool:
	return self.base_damage > 0

func applies_status() -> bool:
	return self.status_name != ""

func adds_status_card() -> bool:
	return self.status_card_name != ""

func applies_element() -> bool:
	return self.element_name != ""

func get_sequential_attack_effects() -> Array[Dictionary]:
	var attack_effects : Array[Dictionary] = []

	# first deals damage
	if self.deals_damage():
		attack_effects.append({
			BattleConstants.EFFECTOR_INSTANCE_ID : self.enemy_instance_id,
			BattleConstants.EFFECT_TYPE : BattleConstants.DAMAGE_EFFECT,
			BattleConstants.EFFECT_AMOUNT : self.base_damage
		})

	# then applies status
	if self.applies_status():
		attack_effects.append({
			BattleConstants.EFFECTOR_INSTANCE_ID : self.enemy_instance_id,
			BattleConstants.EFFECT_TYPE : BattleConstants.STATUS_EFFECT,
			BattleConstants.EFFECT_NAME : self.status_name,
			BattleConstants.EFFECT_AMOUNT : self.status_duration
		})

	# then adds status cards
	if self.adds_status_card():
		attack_effects.append({
			BattleConstants.EFFECTOR_INSTANCE_ID : self.enemy_instance_id,
			BattleConstants.EFFECT_TYPE : BattleConstants.STATUS_CARD_EFFECT,
			BattleConstants.EFFECT_NAME : self.status_card_name,
			BattleConstants.EFFECT_AMOUNT : self.num_status_cards
		})

	# finally applies elements
	if self.applies_element():
		attack_effects.append({
			BattleConstants.EFFECTOR_INSTANCE_ID : self.enemy_instance_id,
			BattleConstants.EFFECT_TYPE : BattleConstants.ELEMENT_EFFECT,
			BattleConstants.EFFECT_NAME : self.element_name,
			BattleConstants.EFFECT_AMOUNT : self.num_applied_element
		})

	return attack_effects

static func create(enemy_attack_data : Dictionary) -> EnemyAttack:
	return EnemyAttack.new(
		enemy_attack_data[EnemyAttack.HUMAN_NAME],
		enemy_attack_data[EnemyAttack.MACHINE_NAME],
		enemy_attack_data[EnemyAttack.ELEMENT_NAME],
		enemy_attack_data[EnemyAttack.NUM_APPLIED_ELEMENT],
		enemy_attack_data[EnemyAttack.STATUS_NAME],
		enemy_attack_data[EnemyAttack.STATUS_DURATION],
		enemy_attack_data[EnemyAttack.STATUS_CARD_NAME],
		enemy_attack_data[EnemyAttack.NUM_STATUS_CARDS],
		enemy_attack_data[EnemyAttack.BASE_DAMAGE],
		enemy_attack_data[EnemyAttack.ENEMY_INSTANCE_ID]
	)

static func by_machine_name(attack_machine_name : String, attack_data : Dictionary) -> EnemyAttack:
	match attack_machine_name:
		EnemyAttack.SLIME_STRIKE:
			return SlimeStrike(
				attack_data[EnemyAttack.ELEMENT_NAME],
				attack_data[EnemyAttack.ENEMY_INSTANCE_ID]
			)
		EnemyAttack.OOZE:
			return Ooze(
				attack_data[EnemyAttack.ELEMENT_NAME],
				attack_data[EnemyAttack.ENEMY_INSTANCE_ID]
			)
		_:
			return

#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const ELEMENT_NAME : String = "element_name"
const NUM_APPLIED_ELEMENT : String = "num_applied_element"
const STATUS_NAME : String = "status_name"
const STATUS_DURATION : String = "status_duration"
const STATUS_CARD_NAME : String = "status_card_name"
const NUM_STATUS_CARDS : String = "num_status_cards"
const BASE_DAMAGE : String = "base_damage"
const ENEMY_INSTANCE_ID : String = "enemy_instance_id"


#=================================
# Enemy Attack machine_name list
#=================================
const SLIME_STRIKE : String = "slime_strike"
const OOZE : String = "ooze"

static func SlimeStrike(attack_element_name : String, instance_id : int) -> EnemyAttack:
	return EnemyAttack.create({
		EnemyAttack.HUMAN_NAME : "Slime Strike",
		EnemyAttack.MACHINE_NAME : EnemyAttack.SLIME_STRIKE,
		EnemyAttack.ELEMENT_NAME : attack_element_name,
		EnemyAttack.NUM_APPLIED_ELEMENT : 1,
		EnemyAttack.STATUS_NAME : "",
		EnemyAttack.STATUS_DURATION : 0,
		EnemyAttack.STATUS_CARD_NAME : "",
		EnemyAttack.NUM_STATUS_CARDS : 0,
		EnemyAttack.BASE_DAMAGE : 10,
		EnemyAttack.ENEMY_INSTANCE_ID : instance_id
	})

static func Ooze(attack_element_name : String, instance_id : int) -> EnemyAttack:
	return EnemyAttack.create({
		EnemyAttack.HUMAN_NAME : "Ooze",
		EnemyAttack.MACHINE_NAME : EnemyAttack.OOZE,
		EnemyAttack.ELEMENT_NAME : attack_element_name,
		EnemyAttack.NUM_APPLIED_ELEMENT : 2,
		EnemyAttack.STATUS_NAME : "",
		EnemyAttack.STATUS_DURATION : 1,
		EnemyAttack.STATUS_CARD_NAME : "",
		EnemyAttack.NUM_STATUS_CARDS : 0,
		EnemyAttack.BASE_DAMAGE : 0,
		EnemyAttack.ENEMY_INSTANCE_ID : instance_id
	})


#=========================
# Attack Effect constants
#=========================
const TYPE : String = "type"
const DAMAGE_TYPE : String = "damage_type"
const STATUS_TYPE : String = "status_type"
const STATUS_CARD_TYPE : String = "status_card_type"
const ELEMENT_TYPE : String = "element_type"
# resolve constants
const FAINTED : String = "fainted"
const DAMAGED : String = "damaged"
const ELEMENT_ADDED : String = "element_added"
