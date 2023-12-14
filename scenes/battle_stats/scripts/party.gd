extends Node


var lead_instance_id : int :
	set = set_lead_instance_id
var lead_current_hp : int :
	set = set_lead_current_hp
var lead_current_element_names : Array[String] :
	set = set_lead_current_element_names

var swap_top_instance_id : int :
	set = set_swap_top_instance_id
var swap_top_current_hp : int :
	set = set_swap_top_current_hp
var swap_top_current_element_names : Array[String] :
	set = set_swap_top_current_element_names

var swap_bottom_instance_id : int :
	set = set_swap_bottom_instance_id
var swap_bottom_current_hp : int :
	set = set_swap_bottom_current_hp
var swap_bottom_current_element_names : Array[String] :
	set = set_swap_bottom_current_element_names


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.ENTITY_DAMAGED, _on_entity_damaged)
	BattleRadio.connect(BattleRadio.ELEMENT_APPLIED_TO_ENTITY, _on_element_applied_to_entity)
	BattleRadio.connect(BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY, _on_elements_removed_from_entity)


#=======================
# Setters
#=======================
func set_lead_instance_id(new_instance_id : int) -> void:
	lead_instance_id = new_instance_id

func set_lead_current_hp(new_current_hp : int) -> void:
	lead_current_hp = new_current_hp

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_HP_UPDATED,
		self.lead_instance_id,
		self.lead_current_hp
	)

func set_lead_current_element_names(new_element_names : Array[String]) -> void:
	lead_current_element_names = new_element_names

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_ELEMENT_NAMES_UPDATED,
		self.lead_instance_id,
		self.lead_current_element_names
	)

func set_swap_top_instance_id(new_instance_id : int) -> void:
	swap_top_instance_id = new_instance_id

func set_swap_top_current_hp(new_current_hp : int) -> void:
	swap_top_current_hp = new_current_hp

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_HP_UPDATED,
		self.swap_top_instance_id,
		self.swap_top_current_hp
	)

func set_swap_top_current_element_names(new_element_names : Array[String]) -> void:
	swap_top_current_element_names = new_element_names

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_ELEMENT_NAMES_UPDATED,
		self.swap_top_instance_id,
		self.swap_top_current_element_names
	)

func set_swap_bottom_instance_id(new_instance_id : int) -> void:
	swap_bottom_instance_id = new_instance_id

func set_swap_bottom_current_hp(new_current_hp : int) -> void:
	swap_bottom_current_hp = new_current_hp

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_HP_UPDATED,
		self.swap_bottom_instance_id,
		self.swap_bottom_current_hp
	)

func set_swap_bottom_current_element_names(new_element_names : Array[String]) -> void:
	swap_bottom_current_element_names = new_element_names

	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_ELEMENT_NAMES_UPDATED,
		self.swap_bottom_instance_id,
		self.swap_bottom_current_element_names
	)


#=======================
# Signal Handlers
#=======================
func _on_battle_started(battle_data : BattleData) -> void:
	lead_instance_id = battle_data.lead_character.get_instance_id()
	lead_current_hp = battle_data.lead_character.current_hp
	lead_current_element_names = []

	swap_top_instance_id = battle_data.top_swap_character.get_instance_id()
	swap_top_current_hp = battle_data.top_swap_character.current_hp
	swap_top_current_element_names = []
	
	swap_bottom_instance_id = battle_data.bottom_swap_character.get_instance_id()
	swap_bottom_current_hp = battle_data.bottom_swap_character.current_hp
	swap_bottom_current_element_names = []

func _on_entity_damaged(entity_instance_id : int, damage : int) -> void:
	if entity_instance_id == self.lead_instance_id:
		lead_current_hp = self.take_damage(self.lead_current_hp, damage)
		return

	if entity_instance_id == self.swap_top_instance_id:
		swap_top_current_hp = self.take_damage(self.swap_top_current_hp, damage)
		return

	if entity_instance_id == self.swap_bottom_instance_id:
		swap_bottom_current_hp = self.take_damage(self.swap_bottom_current_hp, damage)
		return

func _on_element_applied_to_entity(
	entity_instance_id : int,
	element_name : String,
	amount_applied : int
) -> void:
	if entity_instance_id == self.lead_instance_id:
		lead_current_element_names = self.add_elements(
			self.lead_current_element_names,
			element_name,
			amount_applied
		)
		return

	if entity_instance_id == self.swap_top_instance_id:
		swap_top_current_element_names = self.add_elements(
			self.swap_top_current_element_names,
			element_name,
			amount_applied
		)
		return

	if entity_instance_id == self.swap_bottom_instance_id:
		swap_bottom_current_element_names = self.add_elements(
			self.swap_bottom_current_element_names,
			element_name,
			amount_applied
		)
		return

func _on_elements_removed_from_entity(entity_instance_id : int, removed_element_indexes : Array[int]):
	if entity_instance_id == self.lead_instance_id:
		lead_current_element_names = self.remove_elements(
			self.lead_current_element_names,
			removed_element_indexes
		)
		return

	if entity_instance_id == self.swap_top_instance_id:
		swap_top_current_element_names = self.remove_elements(
			self.swap_bottom_current_element_names,
			removed_element_indexes
		)
		return

	if entity_instance_id == self.swap_bottom_instance_id:
		swap_bottom_current_element_names = self.remove_elements(
			self.swap_bottom_current_element_names,
			removed_element_indexes
		)
		return


#=======================
# Data Helpers
#=======================
func party_instance_ids() -> Array[int]:
	return [
		self.lead_instance_id,
		self.swap_top_instance_id,
		self.swap_bottom_instance_id
	]

func take_damage(current_hp : int, damage : int) -> int:
	var remainder : int = current_hp - damage
	if remainder > 0:
		return remainder
	else:
		return 0

func add_elements(
	current_element_names : Array[String],
	added_element_name : String,
	amount_added : int
) -> Array[String]:
	var new_element_names : Array[String] = []

	for current_element_name in current_element_names:
		new_element_names.append(current_element_name)

	for i in amount_added:
		new_element_names.append(added_element_name)

	return new_element_names

func remove_elements(
	current_element_names : Array[String],
	removed_element_indexes : Array[int]
) -> Array:
	var new_element_names : Array[String] = []

	for i in current_element_names.size():
		if not i in [removed_element_indexes]:
			new_element_names.append(current_element_names[i])

	return new_element_names
