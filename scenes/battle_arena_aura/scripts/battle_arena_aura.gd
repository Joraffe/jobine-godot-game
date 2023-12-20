extends Node2D


var aura_element_scene : PackedScene = preload(
	"res://scenes/battle_arena_aura_element/BattleArenaAuraElement.tscn"
)

var entity : Variant :  # used to associate this with an character/enemy
	set = set_entity
var aura_width : int  # used to position individual aura elements
var entity_image_height : int  # used to position the combined aura elements

var element_names : Array[String] :
	set = set_element_names
var elements : Array[Element]
var element_registry : Dictionary

var element_remove_queue : Queue = Queue.new()
var combo_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$ElementTimer.connect("timeout", _on_element_animation_timer_finished)
	$ComboTimer.connect("timeout", _on_combo_delay_finished)
	$FinishTimer.connect("timeout", _on_check_for_finished)


#=======================
# Setters
#=======================
func set_entity(new_entity : Variant) -> void:
	entity = new_entity
	self.position_aura()
	$Area2D.set("entity_instance_id", self.entity.get_instance_id())
	$AI.set("entity_instance_id" , self.entity.get_instance_id())
	$AI.set("entity_type", self.entity.entity_type)

func set_element_names(new_element_names : Array[String]) -> void:
	print('battle_arena_aura.set_element_names called')
	var old_element_names = self.element_names
	element_names = new_element_names
	$Area2D.set("element_names", new_element_names)
	$AI.set("element_names", new_element_names)

	if new_element_names.size() > old_element_names.size():
		print('new > old')
		BattleRadio.emit_signal(
			BattleRadio.ADD_ELEMENTS_ANIMATION_QUEUED,
			self.entity.get_instance_id(),
			self.get_added_element_names(new_element_names, old_element_names)
		)
#	elif new_element_names.size() < old_element_names.size():
#		print('new < old')
#		var remove_indexes = self.get_remove_indexes(new_element_names, old_element_names)
#		var remain_indexes = self.get_remain_indexes(old_element_names, remove_indexes)
#		BattleRadio.emit_signal(
#			BattleRadio.REMOVE_ELEMENTS_ANIMATION_QUEUED,
#			self.entity.get_instance_id(),
#			remove_indexes
#		)
#		BattleRadio.emit_signal(
#			BattleRadio.REPOSITION_ELEMENTS_ANIMATION_QUEUED,
#			self.entity.get_instance_id(),
#			remove_indexes,
#			remain_indexes
#		)

# ignore this
func set_elements(new_elements : Array[Element]) -> void:
	var old_elements : Array[Element] = self.elements
	elements = new_elements

	self.set("element_registry", self.get_element_registry(self.elements))
	self.render_elements(new_elements, old_elements)
	var combos = self.get_all_combos(self.elements, self.element_registry)
	for combo in combos:
		self.element_remove_queue.enqueue(combo)
	if combos.size() > 0:
		$ElementTimer.start()

	if self.elements.size() > 0:
		$FinishTimer.start()


#========================
# Signal Handlers
#========================
func _on_element_animation_timer_finished() -> void:
	var combos = []
	while self.element_remove_queue.size() > 0:
		combos.append(self.element_remove_queue.dequeue())

	if combos.size() > 0:
		var indexes_to_remove : Array[int] = []
		for combo_data in combos:
			indexes_to_remove.append(combo_data[Combo.FIRST_ELEMENT_INDEX])
			indexes_to_remove.append(combo_data[Combo.SECOND_ELEMENT_INDEX])
			self.combo_queue.enqueue(combo_data)
		BattleRadio.emit_signal(
			BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY,
			self.entity.get_instance_id(),
			indexes_to_remove
		)
		$ComboTimer.start()

func _on_combo_delay_finished() -> void:
	var queued_combos = []
	while self.combo_queue.size() > 0:
		queued_combos.append(self.combo_queue.dequeue())

	if queued_combos.size() > 0:
		var combos : Array[Combo] = []
		for combo_data in queued_combos:
			var combo : Combo = Combo.create({
				Combo.FIRST_ELEMENT : combo_data[Combo.FIRST_ELEMENT],
				Combo.SECOND_ELEMENT : combo_data[Combo.SECOND_ELEMENT]
			})
			combos.append(combo)
		BattleRadio.emit_signal(
			BattleRadio.COMBOS_APPLIED,
			self.entity.get_instance_id(),
			combos
		)

func _on_check_for_finished() -> void:
	if self.element_remove_queue.is_empty() and self.combo_queue.is_empty():
		BattleRadio.emit_signal(BattleRadio.ELEMENTS_SETTLED)
	else:
		$FinishTimer.start()


#========================
# Aura Functionality
#========================
func get_added_element_names(
	new_element_names : Array[String],
	old_element_names : Array[String],
) -> Array[String]:
	var added_element_names : Array[String] = []

	var new_element_counter : Dictionary = {}
	for new_element_name in new_element_names:
		if not new_element_counter.has(new_element_name):
			new_element_counter[new_element_name] = 1
		else:
			new_element_counter[new_element_name] += 1

	var old_element_counter : Dictionary = {}
	for old_element_name in old_element_names:
		if not old_element_counter.has(old_element_name):
			old_element_counter[old_element_name] = 1
		else:
			old_element_counter[old_element_name] += 1

	for new_element_name in new_element_counter.keys():
		var new_element_count : int = new_element_counter.get(new_element_name)
		var old_element_count : int = old_element_counter.get(new_element_name, 0)
		var added_element_count : int = new_element_count - old_element_count
		for i in added_element_count:
			added_element_names.append(new_element_name)

	return added_element_names

func get_remove_indexes(
	new_element_names : Array[String],
	old_element_names : Array[String]
) -> Array[int]:
	var removed_element_names : Array[String] = ArrayUtils.difference(
		old_element_names,
		new_element_names
	)
	var remove_indexes : Array[int] = []

	var claimed_indexes : Array[int] = []
	for removed_element_name in removed_element_names:
		for i in old_element_names.size():
			if i in claimed_indexes:
				continue
			if removed_element_name == old_element_names[i]:
				remove_indexes.append(i)

	return remove_indexes

func get_remain_indexes(
	old_element_names : Array[String],
	remove_indexes : Array[int]
) -> Array[int]:
	var remain_indexes : Array[int] = []

	for i in old_element_names.size():
		if i not in remove_indexes:
			remain_indexes.append(i)

	return remain_indexes

func get_element_registry(new_elements : Array[Element]) -> Dictionary:
	var new_element_registry : Dictionary = {}

	for i in new_elements.size():
		var element : Element = new_elements[i]
		if not new_element_registry.has(element.machine_name):
			new_element_registry[element.machine_name] = 1
		else:
			new_element_registry[element.machine_name] += 1

	return new_element_registry

func get_total_elements_in_registry(registry : Dictionary) -> int:
	var total_elements : int = 0
	for element_name in registry.keys():
		total_elements += registry.get(element_name)
	return total_elements

func get_new_non_rendered_element_names(
	new_elements : Array[Element],
	old_elements : Array[Element]
) -> Array[String]:
	var new_unrendered_elements : Array[String] = []

	var new_counter : Dictionary = self.get_element_registry(new_elements)
	var old_counter : Dictionary = self.get_element_registry(old_elements)
	var new_counter_elements : Array = new_counter.keys()
	var old_counter_elements : Array = old_counter.keys()
	var in_new_and_not_in_old : Array[String] = []
	var in_both_new_and_old : Array[String] = []

	for element_name in new_counter_elements:
		if element_name not in old_counter_elements:
			in_new_and_not_in_old.append(element_name)
		else:
			in_both_new_and_old.append(element_name)

	for element_name in in_new_and_not_in_old:
		for i in new_counter.get(element_name):
			new_unrendered_elements.append(element_name)

	for element_name in in_both_new_and_old:
		var count : int = new_counter.get(element_name) - old_counter.get(element_name)
		for i in count:
			new_unrendered_elements.append(element_name)

	return new_unrendered_elements

func get_old_remaining_element_names(
	new_elements : Array[Element],
	old_elements : Array[Element],
	old_removed_element_names : Array[String]
) -> Array[Dictionary]:
	var old_remaining_element_data : Array[Dictionary] = []
	var old_remaining_element_names : Array[String] = []

	var new_counter : Dictionary = self.get_element_registry(new_elements)
	var old_counter : Dictionary = self.get_element_registry(old_elements)
	var new_counter_elements : Array = new_counter.keys()
	var old_counter_elements : Array = old_counter.keys()
	var in_both_new_and_old : Array[String] = []

	for element_name in old_counter_elements:
		if element_name in new_counter_elements:
			in_both_new_and_old.append(element_name)

	for element_name in in_both_new_and_old:
		var min_amount : int = self.get_min(
			old_counter.get(element_name),
			new_counter.get(element_name)
		)
		for count in min_amount:
			old_remaining_element_names.append(element_name)

	for remaining_element_name in old_remaining_element_names:
		var count_same_element_removed : int = 0
		for removed_element_name in old_removed_element_names:
			if removed_element_name == remaining_element_name:
				count_same_element_removed += 1
		old_remaining_element_data.append({
			"element_name": remaining_element_name,
			"count_removed": count_same_element_removed
		})

	return old_remaining_element_data

func get_old_removed_element_names(
	new_elements : Array[Element],
	old_elements : Array[Element]
) -> Array[String]:
	var old_removed_element_names : Array[String] = []

	var new_counter : Dictionary = self.get_element_registry(new_elements)
	var old_counter : Dictionary = self.get_element_registry(old_elements)
	var new_counter_elements : Array = new_counter.keys()
	var old_counter_elements : Array = old_counter.keys()
	var in_both_new_and_old : Array[String] = []
	var in_old_but_not_new : Array[String] = []
	
	for element_name in old_counter_elements:
		if element_name in new_counter_elements:
			in_both_new_and_old.append(element_name)
		else:
			in_old_but_not_new.append(element_name)

	for element_name in in_old_but_not_new:
		for i in old_counter.get(element_name):
			old_removed_element_names.append(element_name)

	for element_name in in_both_new_and_old:
		var count : int = old_counter.get(element_name) - new_counter.get(element_name)
		for i in count:
			old_removed_element_names.append(element_name)

	return old_removed_element_names


func render_elements(new_elements : Array[Element], old_elements : Array[Element]) -> void:
	# Figure out which elements to reposition
	# and which elements to newly render

	var old_removed_element_names  = self.get_old_removed_element_names(
		new_elements,
		old_elements
	)
	var new_unrendered_element_names = self.get_new_non_rendered_element_names(
		new_elements,
		old_elements
	)
	var old_remaining_element_dicts = self.get_old_remaining_element_names(
		new_elements,
		old_elements,
		old_removed_element_names,
	)
	# Remove the old removed elements
	if old_removed_element_names.size() > 0:
		self.tween_up_and_free_element_names(old_removed_element_names)

	# Reposition the already-rendered elements
	if old_remaining_element_dicts.size() > 0:
		self.tween_reposition_element_names(old_remaining_element_dicts)

	# Render the elements that aren't rendered
	if new_unrendered_element_names.size() > 0:
		self.render_new_element_names(new_unrendered_element_names)

func registry_has_multiple_distinct_elements(registry : Dictionary) -> bool:
	return registry.keys().size() >= 2

func get_all_combos(possible_elements : Array[Element], registry : Dictionary) -> Array[Dictionary]:
	var combos : Array[Dictionary] = []
	var claimed_indexes : Array[int] = []

	if not self.registry_has_multiple_distinct_elements(registry):
		return combos

	for i in possible_elements.size():
		if i in claimed_indexes:
			continue

		var current_element = possible_elements[i]
		for j in range(i + 1, possible_elements.size()):
			if j in claimed_indexes:
				continue

			var compared_element = possible_elements[j]
			var potential_combo : Combo = Combo.create({
				Combo.FIRST_ELEMENT : current_element,
				Combo.SECOND_ELEMENT : compared_element
			})
			if potential_combo.has_reaction():
				claimed_indexes.append(i)
				claimed_indexes.append(j)
				combos.append({
					Combo.FIRST_ELEMENT_INDEX : i,
					Combo.FIRST_ELEMENT : current_element,
					Combo.FIRST_ELEMENT_NAME : current_element.machine_name,
					Combo.SECOND_ELEMENT_INDEX : j,
					Combo.SECOND_ELEMENT : compared_element,
					Combo.SECOND_ELEMENT_NAME : compared_element.machine_name
				})
				break

	return combos

func check_elements_for_combo(possible_elements : Array[Element], registry : Dictionary) -> Dictionary:
	# TODO get all combos if there are multiple
	var combo_data : Dictionary

	# Need at least 2 diff elements to combine
	if not self.registry_has_multiple_distinct_elements(registry):
		combo_data = {}
	else:
		for index in possible_elements.size():
			combo_data = self.check_element_index_for_combo(
				possible_elements,
				index
			)
			if not combo_data.is_empty():
				break

	return combo_data

func check_element_index_for_combo(possible_elements : Array[Element], index : int) -> Dictionary:
	var combo_data : Dictionary = {}

	var element : Element = possible_elements[index]	
	for compared_index in possible_elements.size():
		if compared_index == index:
			continue

		var compared_element : Element = possible_elements[compared_index]
		var potential_combo : Combo = Combo.create({
			Combo.FIRST_ELEMENT : element,
			Combo.SECOND_ELEMENT : compared_element
		})
		if potential_combo.has_reaction():
			combo_data = {
				Combo.FIRST_ELEMENT_INDEX : index,
				Combo.FIRST_ELEMENT : element,
				Combo.SECOND_ELEMENT_INDEX : compared_index,
				Combo.SECOND_ELEMENT : compared_element
			}
			break

	return combo_data


#=====================
# Data Helpers
#=====================
func instantiate_aura_element(element : Element) -> Node2D:
	var instance = aura_element_scene.instantiate()
	instance.set("element", element)
	add_child(instance)
	return instance

func get_max(num_1 : int, num_2 : int) -> int:
	if num_1 > num_2:
		return num_1
	elif num_2 > num_1:
		return num_2
	else:
		return num_1

func get_min(num_1 : int, num_2 : int) -> int:
	if num_1 < num_2:
		return num_1
	elif num_2 < num_1:
		return num_2
	else:
		return num_1

func has_index(array, index) -> bool:
	return index >= 0 and index < array.size()


#=====================
# Node Helpers
#=====================
func get_aura_element_position_x(instance : Node2D, position_index : int) -> int:
	var aura_element_width : int = instance.image_data.get_img_width()
	var starting_x : int = (-1 * int(aura_width / 2.0)) + int(aura_element_width / 2.0)
	var offset_x : int = (position_index * aura_element_width) + (position_index * 10)
	return starting_x + offset_x

func position_aura_element(instance : Node2D, position_index : int) -> void:
	var position_x = get_aura_element_position_x(instance, position_index)
	instance.position.x = position_x

func tween_reposition_element_names(element_name_dicts : Array[Dictionary]) -> void:
	var claimed_child_indexes = []
	var children_to_tween = []
	var num_children = self.get_child_count()
	for element_name_dict in element_name_dicts:
		var desired_element_position : int = element_name_dict["count_removed"]
		var num_same_element_visited = 0
		for i in num_children:
			if i in claimed_child_indexes:
				continue
			var child = self.get_child(i)
			if (
				child.get("element") is Element
				and child.get("element").machine_name == element_name_dict["element_name"]
			):
				if desired_element_position == num_same_element_visited:
					claimed_child_indexes.append(i)
					children_to_tween.append(child)
					break
				else:
					num_same_element_visited += 1

	for i in children_to_tween.size():
		var child = children_to_tween[i]
		var position_x = get_aura_element_position_x(child, i)
		if position_x != child.position.x:
			var tween = create_tween()
			tween.tween_property(
				child,
				"position",
				Vector2(position_x, child.position.y),
				0.5
			)

func tween_up_and_free_element_names(element_names_to_tween : Array[String]) -> void:
	var visited_indexes = []
	var children_to_tween = []
	var num_children = self.get_child_count()
	for element_name in element_names_to_tween:
		for i in num_children:
			if i in visited_indexes:
				continue

			var child = self.get_child(i)
			if child.get("element") is Element:
				if child.get("element").machine_name == element_name:
					children_to_tween.append(child)
					visited_indexes.append(i)
					break

	for child in children_to_tween:
		var tween = self.create_tween()
		var cur_position = child.position
		var new_position = Vector2(cur_position.x, cur_position.y - 50)
		tween.tween_property(
			child,
			"position",
			new_position,
			0.5
		)
		tween.tween_callback(child.queue_free)

func render_new_element_names(element_names_to_render : Array[String]) -> void:
	var total_elements : int = self.get_total_elements_in_registry(self.element_registry)
	var index_to_render : int =  total_elements - element_names_to_render.size()
	for element_name in element_names_to_render:
		var new_unrendered_element : Element = Element.by_machine_name(element_name)
		var instance = instantiate_aura_element(new_unrendered_element)
		position_aura_element(instance, index_to_render)
		index_to_render += 1

func position_aura() -> void:
	self.position.y = ((-1) * int(self.entity_image_height / 2.0) - 30)
