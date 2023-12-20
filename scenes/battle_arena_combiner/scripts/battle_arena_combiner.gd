extends Node


@onready var entity_group_node : Node2D = get_parent()


var entity_ids : Array[int] :
	set = set_entity_ids

# Related to combining elements
var first_element : Element
var second_element : Element
var combo_targeting_instance_id : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.COMBO_APPLIED, _on_combo_applied)
	BattleRadio.connect(BattleRadio.COMBOS_APPLIED, _on_combos_applied)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)


#=======================
# Setters
#=======================
func set_entity_ids(new_entity_ids : Array[int]) -> void:
	entity_ids = new_entity_ids


#=======================
# Signal Handlers
#=======================
func _on_combo_applied(instance_id : int, combo : Combo) -> void:
	if not is_applicable(instance_id):
		return

	var targeting : Targeting = Targeting.by_machine_name(
		combo.targeting_name,
		instance_id
	)
	if targeting.is_single_targeting():
		self.apply_combo_to_entity(instance_id, combo)
		return

	if targeting.is_splash_targeting():
		for entity_instance_id in self.get_splash_entity_ids(instance_id):
			self.apply_combo_to_entity(entity_instance_id, combo)
		return

	if targeting.is_all_targeting():
		for entity_id in self.entity_ids:
			self.apply_combo_to_entity(entity_id, combo)
		return

func _on_combos_applied(instance_id : int, combos : Array[Combo]) -> void:
	if not self.is_applicable(instance_id):
		return

	for combo in combos:
		var targeting : Targeting = Targeting.by_machine_name(
			combo.targeting_name,
			instance_id
		)
		if targeting.is_single_targeting():
			self.apply_combo_to_entity(instance_id, combo)
			continue

		if targeting.is_splash_targeting():
			for entity_instance_id in self.get_splash_entity_ids(instance_id):
				self.apply_combo_to_entity(entity_instance_id, combo)
			continue

		if targeting.is_all_targeting():
			for entity_id in self.entity_ids:
				self.apply_combo_to_entity(entity_id, combo)
			continue

func _on_combo_bonus_applied(
	instance_id : int,
	combo_bonus : ComboBonus,
	targeting : Targeting
) -> void:
	if not self.is_applicable(instance_id):
		return

	if not combo_bonus.is_extra_damage():
		return

	if targeting.is_single_targeting():
		self.apply_combo_bonus_to_entity(instance_id, combo_bonus)
		return

	if targeting.is_splash_targeting():
		for entity_instance_id in self.get_splash_entity_ids(instance_id):
			self.apply_combo_bonus_to_entity(entity_instance_id, combo_bonus)
		return

	if targeting.is_all_targeting():
		for entity_id in self.entity_ids:
			self.apply_combo_bonus_to_entity(entity_id, combo_bonus)
		return


#=======================
# Node Helpers
#=======================
func is_applicable(applicable_instance_id : int) -> bool:
	for entity_id in self.entity_ids:
		if entity_id == applicable_instance_id:
			return true

	return false

func get_entity_node_from_entity_group(entity_instance_id : int) -> Node2D:
	return self.entity_group_node.get_child_node_by_instance_id(entity_instance_id)


#=======================
# Combo Logic
#=======================
func apply_combo_to_entity(entity_instance_id : int, combo : Combo) -> void:
	self.apply_combo_damage_to_entity(entity_instance_id, combo)
	self.apply_combo_elements_to_entity(entity_instance_id, combo)

func apply_combo_damage_to_entity(entity_instance_id : int, combo : Combo) -> void:
	if combo.base_damage != 0:
		BattleRadio.emit_signal(
			BattleRadio.ENTITY_DAMAGED,
			entity_instance_id,
			combo.base_damage
		)

func apply_combo_elements_to_entity(entity_instance_id : int, combo : Combo) -> void:
	if combo.applied_element_name != "":
		BattleRadio.emit_signal(
			BattleRadio.ELEMENT_APPLIED_TO_ENTITY,
			entity_instance_id,
			combo.applied_element_name,
			combo.num_applied_element
		)


#=======================
# Combo Bonus Logic
#=======================
func apply_combo_bonus_to_entity(entity_instance_id : int, combo_bonus : ComboBonus) -> void:
	self.apply_combo_bonus_damage_to_entity(entity_instance_id, combo_bonus)

func apply_combo_bonus_damage_to_entity(entity_instance_id : int, combo_bonus : ComboBonus) -> void:
	if combo_bonus.is_extra_damage():
		BattleRadio.emit_signal(
			BattleRadio.ENTITY_DAMAGED,
			entity_instance_id,
			combo_bonus.damage
		)


#=======================
# Targeting Logic
#=======================
func get_blast_entity_ids(target_instance_id : int) -> Array[int]:
	var blast_entity_ids : Array[int] = [target_instance_id]

	var left_i : int
	var right_i : int
	for i in range(0, self.entity_ids.size() - 1):
		if self.entity_ids[i] == target_instance_id:
			left_i = i - 1
			right_i = i + 1

	if left_i >= 0:
		blast_entity_ids.append(self.entity_ids[left_i])
	if right_i <= self.entity_ids.size() - 1:
		blast_entity_ids.append(self.entity_ids[right_i])

	return blast_entity_ids


func get_splash_entity_ids(target_instance_id : int) -> Array[int]:
	var splash_entity_ids : Array[int] = [target_instance_id]

	var left_i : int
	var right_i : int
	for i in range(0, self.entity_ids.size() - 1):
		if self.entity_ids[i] == target_instance_id:
			left_i = i - 1
			right_i = i + 1

	var possible_indexes : Array[int] = []
	if left_i >= 0:
		possible_indexes.append(left_i)
	if right_i <= self.entity_ids.size() - 1:
		possible_indexes.append(right_i)

	var rand_i = randi_range(0, possible_indexes.size() - 1)
	var splash_i = possible_indexes[rand_i]
	splash_entity_ids.append(self.entity_ids[splash_i])

	return splash_entity_ids
