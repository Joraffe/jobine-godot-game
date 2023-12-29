extends Resource
class_name Enemy


signal status_effect_duration_updated(instance_id : int, new_duration : int)
signal new_status_effect_added(new_status_effect : StatusEffect)
signal status_effects_removed(removed_status_effects : Array[StatusEffect])
signal status_effects_remained(remained_status_effects : Array[StatusEffect])


var human_name : String
var machine_name : String
var element_name : String
var max_hp : int
var current_hp : int
var current_element_names : Array[String]
var entity_type : String
var attack_names : Array[String]
var current_status_effects : Array[StatusEffect]

func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int,
	_current_element_names : Array[String],
	_entity_type : String,
	_attack_names : Array[String],
	_current_status_effects : Array[StatusEffect]
):
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	max_hp = _max_hp
	current_hp = _current_hp
	current_element_names = _current_element_names
	entity_type = _entity_type
	attack_names = _attack_names
	current_status_effects = _current_status_effects

func take_damage(damage : int) -> void:
	var old_current_hp : int = self.current_hp
	var remaining_hp : int = old_current_hp - damage
	if remaining_hp < 0:
		remaining_hp = 0
	self.set("current_hp", remaining_hp)

func has_fainted() -> bool:
	return self.current_hp == 0

func is_frozen() -> bool:
	var enemy_is_frozen : bool = false

	for status_effect in self.current_status_effects:
		if status_effect.machine_name == StatusEffect.FROZEN:
			enemy_is_frozen = true
			break

	return enemy_is_frozen

func can_attack() -> bool:
	if self.is_frozen():
		return false
	else:
		return true

func get_random_attack_name() -> String:
	var rng = RandomNumberGenerator.new()
	var rand_i = rng.randi_range(0, self.attack_names.size() - 1)
#	var rand_i = 1
	return attack_names[rand_i]

func add_element_names(element_names_to_add : Array[String]) -> void:
	self.set(
		"current_element_names",
		self.current_element_names + element_names_to_add
	)

func remove_elements_at_indexes(indexes_to_remove : Array[int]) -> void:
	var new_elements : Array[String] = []
	for i in self.current_element_names.size():
		if not i in indexes_to_remove:
			new_elements.append(self.current_element_names[i])
	self.set("current_element_names", new_elements)

func has_status_effects() -> bool:
	return self.current_status_effects.size() > 0

func add_status_effect(added_status_effect_name : String, added_duration : int) -> void:
	for current_status_effect in self.current_status_effects:
		if added_status_effect_name == current_status_effect.machine_name:
			current_status_effect.duration += added_duration
			self.emit_signal(
				BattleConstants.STATUS_EFFECT_DURATION_UPDATED,
				current_status_effect.get_instance_id(),
				current_status_effect.duration
			)
			return

	# if we've made it here, then we need to add a new status effect
	var new_status_effect : StatusEffect = StatusEffect.by_machine_name(
		added_status_effect_name,
		added_duration
	)
	self.current_status_effects.append(new_status_effect)
	self.emit_signal(
		BattleConstants.NEW_STATUS_EFFECT_ADDED,
		new_status_effect
	)

func remove_duration_from_status_effect(removed_status_effect_name : String, duration_to_remove : int) -> void:
	for status_effect in self.current_status_effects:
		if status_effect.machine_name == removed_status_effect_name:
			status_effect.duration -= duration_to_remove

func get_reducable_status_effects() -> Array[StatusEffect]:
	var reduceable_status_effects : Array[StatusEffect] = []

	for status_effect in self.current_status_effects:
		if status_effect.reduces_on_turn_end:
			reduceable_status_effects.append(status_effect)

	return reduceable_status_effects

func filter_zero_duration_status_effects() -> void:
	var remaining : Array[StatusEffect] = []
	var removed : Array[StatusEffect] = []
	for status_effect in self.current_status_effects:
		if status_effect.duration > 0:
			remaining.append(status_effect)
		else:
			removed.append(status_effect)

	if removed:
		self.set("current_status_effects", remaining)
		self.emit_signal(BattleConstants.STATUS_EFFECTS_REMOVED, removed)

	if remaining:
		self.emit_signal(BattleConstants.STATUS_EFFECTS_REMAINED, remaining)

func belongs_to_group(group_name : String) -> bool:
	return group_name == BattleConstants.GROUP_ENEMIES

static func create(enemy_data : Dictionary) -> Enemy:
	return Enemy.new(
		enemy_data[Enemy.HUMAN_NAME],
		enemy_data[Enemy.MACHINE_NAME],
		enemy_data[Enemy.ELEMENT_NAME],
		enemy_data[Enemy.MAX_HP],
		enemy_data[Enemy.CURRENT_HP],
		enemy_data[Enemy.CURRENT_ELEMENT_NAMES],
		enemy_data[Enemy.ENTITY_TYPE],
		enemy_data[Enemy.ATTACK_NAMES],
		enemy_data[Enemy.CURRENT_STATUS_EFFECTS]
	)

static func create_multi(enemies_data : Array[Dictionary]) -> Array[Enemy]:
	var enemies : Array[Enemy] = []

	for enemy_data in enemies_data:
		enemies.append(Enemy.create(enemy_data))
	
	return enemies


#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const ELEMENT_NAME : String = "element_name"
const MAX_HP : String = "max_hp"
const CURRENT_HP : String = "current_hp"
const CURRENT_ELEMENT_NAMES : String = "current_element_names"
const ENTITY_TYPE : String = "entity_type"
const ATTACK_NAMES : String = "attack_names"
const CURRENT_STATUS_EFFECTS : String = "current_status_effects"


#============================
# Enemy machine_name list
#============================
static func get_random_enemy_machine_name() -> String:
	var rng = RandomNumberGenerator.new()
	var rand_i = rng.randi_range(0, Enemy.ALL_ENEMIES.size() - 1)
	return Enemy.ALL_ENEMIES[rand_i]

static func slime_enemy_name_by_element(slime_element : String) -> String:
	match slime_element:
		Element.FIRE:
			return Enemy.FIRE_SLIME
		Element.WATER:
			return Enemy.WATER_SLIME
		Element.NATURE:
			return Enemy.NATURE_SLIME
		Element.VOLT:
			return Enemy.VOLT_SLIME
		Element.ICE:
			return Enemy.ICE_SLIME
		Element.AERO:
			return Enemy.AERO_SLIME
		_:
			return ""

const ALL_ENEMIES : Array[String] = [
	Enemy.FIRE_SLIME,
	Enemy.WATER_SLIME,
	Enemy.NATURE_SLIME,
	Enemy.VOLT_SLIME,
	Enemy.ICE_SLIME,
	Enemy.AERO_SLIME
]
const FIRE_SLIME : String = "fire_slime"
const WATER_SLIME : String = "water_slime"
const NATURE_SLIME : String = "nature_slime"
const VOLT_SLIME : String = "volt_slime"
const ICE_SLIME : String = "ice_slime"
const AERO_SLIME : String = "aero_slime"


#============================
# Other constants
#============================
const ENTITY_TYPE_ENEMY : String = "enemy"
const ENTITY_TYPE_BOSS : String = "boss"
