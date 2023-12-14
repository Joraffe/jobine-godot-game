extends Node


var enemies_instance_ids : Array[int] :
	set = set_enemies_instance_ids
var enemies_current_hp : Array[int] :
	set = set_enemies_current_hp
var enemies_current_element_names : Array[Array] :
	set = set_enemies_current_element_names

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
func set_enemies_instance_ids(new_instance_ids : Array[int]) -> void:
	enemies_instance_ids = new_instance_ids

func set_enemies_current_hp(new_enemies_current_hp : Array[int]) -> void:
	var zipped = self.zip(self.enemies_current_hp, new_enemies_current_hp)
	for i in zipped.size():
		var current_hp_pair = zipped[i]
		var old_current_hp = current_hp_pair[0]
		var new_current_hp = current_hp_pair[1]

		if old_current_hp != new_current_hp:
			BattleRadio.emit_signal(
				BattleRadio.ENTITY_CURRENT_HP_UPDATED,
				self.enemies_instance_ids[i],
				new_current_hp
			)
	enemies_current_hp = new_enemies_current_hp

func set_enemies_current_element_names(new_current_element_names : Array[Array]) -> void:
	var zipped = self.zip(self.enemies_current_element_names, new_current_element_names)
	for i in zipped.size():
		var current_elements_pair = zipped[i]
		var old_current_elements = current_elements_pair[0]
		var new_current_elements = current_elements_pair[1]
		if old_current_elements == null:
			continue
		if new_current_elements == null:
			continue
		if old_current_elements.size() != new_current_elements.size():
			BattleRadio.emit_signal(
				BattleRadio.ENTITY_CURRENT_ELEMENT_NAMES_UPDATED,
				self.enemies_instance_ids[i],
				new_current_elements
			)
	enemies_current_element_names = new_current_element_names


#=======================
# Signal Handlers
#=======================
func _on_battle_started(battle_data : BattleData) -> void:
	var instance_ids : Array[int] = []
	var current_hps : Array[int] = []
	var current_elements : Array[Array] = []

	for enemy in battle_data.enemies:
		instance_ids.append(enemy.get_instance_id())
		current_hps.append(enemy.current_hp)
		current_elements.append([])

	enemies_instance_ids = instance_ids
	enemies_current_hp = current_hps
	enemies_current_element_names = current_elements

func _on_entity_damaged(instance_id : int, damage : int) -> void:
	var entity_index

	for i in self.enemies_instance_ids.size():
		if instance_id == self.enemies_instance_ids[i]:
			entity_index = i

	if entity_index == null:
		return

	var entity_current_hp : int = self.enemies_current_hp[entity_index]
	var new_current_hp : int = self.take_damage(entity_current_hp, damage)

	var new_current_hps : Array[int] = []
	for i in self.enemies_current_hp.size():
		if entity_index == i:
			new_current_hps.append(new_current_hp)
		else:
			new_current_hps.append(self.enemies_current_hp[i])

	enemies_current_hp = new_current_hps

func _on_element_applied_to_entity(
	instance_id : int,
	element_name : String,
	amount_applied : int
) -> void:
	var entity_index
	for i in self.enemies_instance_ids.size():
		if instance_id == self.enemies_instance_ids[i]:
			entity_index = i

	if entity_index == null:
		return

	var current_elements : Array = self.enemies_current_element_names[entity_index]
	var new_entity_current_elements : Array = self.add_elements(
		current_elements,
		element_name,
		amount_applied
	)


	var new_current_elements : Array[Array] = []
	for i in self.enemies_current_element_names.size():
		if entity_index == i:
			new_current_elements.append(new_entity_current_elements)
		else:
			new_current_elements.append(self.enemies_current_element_names[i])

	enemies_current_element_names = new_current_elements

func _on_elements_removed_from_entity(instance_id : int, removed_element_indexes : Array[int]):
	var entity_index

	for i in self.enemies_instance_ids.size():
		if instance_id == self.enemies_instance_ids[i]:
			entity_index = i

	if entity_index == null:
		return

	var current_elements : Array = self.enemies_current_element_names[entity_index]
	var new_entity_current_elements : Array = self.remove_elements(
		current_elements,
		removed_element_indexes
	)

	var new_current_elements : Array[Array] = []
	for i in self.enemies_current_element_names.size():
		if entity_index == i:
			new_current_elements.append(new_entity_current_elements)
		else:
			new_current_elements.append(self.enemies_current_element_names[i])

	enemies_current_element_names = new_current_elements

#=======================
# Data Helpers
#=======================
func take_damage(current_hp : int, damage : int) -> int:
	var remainder : int = current_hp - damage
	if remainder > 0:
		return remainder
	else:
		return 0

func add_elements(
	current_element_names : Array,
	added_element_name : String,
	amount_added : int
) -> Array:
	var new_element_names : Array = []

	for i in current_element_names.size():
		new_element_names.append(current_element_names[i])

	for i in amount_added:
		new_element_names.append(added_element_name)

	return new_element_names

func remove_elements(
	current_element_names : Array,
	removed_element_indexes : Array[int]
) -> Array:
	var new_element_names : Array = []
	for i in current_element_names.size():
		if not i in removed_element_indexes:
			new_element_names.append(current_element_names[i])

	return new_element_names

func zip(array_1, array_2):
	var zipped = []

	for i in self.get_max(array_1.size(), array_2.size()):
		var array_1_val
		if self.has_index(array_1, i):
			array_1_val = array_1[i]
		else:
			array_1_val = null

		var array_2_val
		if self.has_index(array_2, i):
			array_2_val = array_2[i]
		else:
			array_2_val = null

		zipped.append([array_1_val, array_2_val])

	return zipped

func get_max(num_1, num_2) -> int:
	if num_1 > num_2:
		return num_1
	elif num_2 > num_1:
		return num_2
	else:
		return num_1

func has_index(array, index) -> bool:
	return index >= 0 and index < array.size()
