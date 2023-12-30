extends Resource
class_name Character


signal status_effect_duration_updated(instance_id : int, new_duration : int)
signal new_status_effect_added(new_status_effect : StatusEffect)
signal new_status_effect_not_added(new_status_effect_name : String)
signal new_status_effect_displayed(new_status_effect : StatusEffect)
signal status_effects_removed(removed_status_effects : Array[StatusEffect])
signal status_effects_remained(remained_status_effects : Array[StatusEffect])


var human_name : String
var machine_name : String
var element_name : String
var max_hp : int
var current_hp : int
var current_element_names : Array[String]
var entity_type : String
var current_status_effects : Array[StatusEffect]


func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int,
	_current_element_names : Array[String],
	_entity_type : String,
	_current_status_effect : Array[StatusEffect]
):
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	max_hp = _max_hp
	current_hp = _current_hp
	current_element_names = _current_element_names
	entity_type = _entity_type
	current_status_effects = _current_status_effect

func take_damage(damage : int) -> void:
	var old_current_hp : int = self.current_hp
	var remaining_hp : int = old_current_hp - damage
	if remaining_hp < 0:
		remaining_hp = 0
	self.set("current_hp", remaining_hp)

func has_fainted() -> bool:
	return self.current_hp == 0

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

func has_end_turn_effects() -> bool:
	for status_effect in self.current_status_effects:
		if status_effect.machine_name in StatusEffect.END_TURN_EFFECTS:
			return true

	return false

func has_end_turn_animation() -> bool:
	for status_effect in self.current_status_effects:
		if status_effect.machine_name in StatusEffect.END_TURN_ANIMATIONS:
			return true

	return false

func get_end_turn_animation_name() -> String:
	var end_turn_animation : String = ""


	for status_effect in self.current_status_effects:
		if status_effect.has_end_turn_animation():
			end_turn_animation = status_effect.get_end_turn_animation_name()

	return end_turn_animation

func has_reduceable_status_effects() -> bool:
	for status_effect in self.current_status_effects:
		if status_effect.reduces_on_turn_end:
			return true

	return false

func can_be_inflicted_by(status_effect_name : String) -> bool:
	if status_effect_name == StatusEffect.FROZEN:
		if self.has_frozen_immunity():
			return false

	return true

func has_frozen_immunity() -> bool:
	for status_effect in self.current_status_effects:
		if status_effect.machine_name == StatusEffect.FROZEN_IMMUNE:
			return true

	return false

func can_act() -> bool:
	# certain status effects prevent being able to act/play cards
	var prevents_action : Array[String] = [StatusEffect.FROZEN]

	for status_effect in self.current_status_effects:
		if status_effect.machine_name in prevents_action:
			return false

	return true

func is_frozen() -> bool:
	for status_effect in self.current_status_effects:
		if status_effect.machine_name == StatusEffect.FROZEN:
			return true

	return false

func get_displayable_status_effect() -> StatusEffect:
	var displayable_status_effect : StatusEffect

	for status_effect in self.current_status_effects:
		if status_effect.displays_on_entity:
			displayable_status_effect = status_effect
			break

	return displayable_status_effect

func add_status_effect(added_status_effect_name : String, added_duration : int) -> void:
	if not self.can_be_inflicted_by(added_status_effect_name):
		self.emit_signal(
			BattleConstants.NEW_STATUS_EFFECT_NOT_ADDED,
			added_status_effect_name
		)
		return

	for current_status_effect in self.current_status_effects:
		if added_status_effect_name == current_status_effect.machine_name:
			if current_status_effect.stackable:
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
	if new_status_effect.displays_on_entity:
		self.emit_signal(
			BattleConstants.NEW_STATUS_EFFECT_DISPLAYED,
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
	return group_name == BattleConstants.GROUP_PARTY

static func create(character_data : Dictionary) -> Character:
	return Character.new(
		character_data[Character.HUMAN_NAME],
		character_data[Character.MACHINE_NAME],
		character_data[Character.ELEMENT_NAME],
		character_data[Character.MAX_HP],
		character_data[Character.CURRENT_HP],
		character_data[Character.CURRENT_ELEMENT_NAMES],
		character_data[Character.ENTITY_TYPE],
		character_data[Character.CURRENT_STATUS_EFFECTS]
	)


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
const CURRENT_STATUS_EFFECTS : String = "current_status_effects"


#============================
# Character machine_name list
#============================
const JUNO : String = "juno"
const PETTOL : String = "pettol"
const AXO : String = "axo"

#============================
# Other constants
#============================
const ENTITY_TYPE_CHARACTER : String = "character"
