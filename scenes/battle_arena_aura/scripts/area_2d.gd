extends Area2D


var aura_element_scene : PackedScene = preload(
	"res://scenes/battle_arena_aura_element/BattleArenaAuraElement.tscn"
)
var aura_width : int  # used to position the aura element

var entity_instance_id : int
var element_names : Array[String]

var remove_queue : Queue = Queue.new()
var free_queue : Queue = Queue.new()
var reposition_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ADD_ELEMENTS_ANIMATION_QUEUED, _on_add_elements_animation_queued)
	BattleRadio.connect(BattleRadio.REMOVE_ELEMENTS_ANIMATION_QUEUED, _on_remove_elements_animation_queued)
	BattleRadio.connect(BattleRadio.REPOSITION_ELEMENTS_ANIMATION_QUEUED, _on_reposition_elements_animation_queued)


#=======================
# Signal Handlers
#=======================
func _on_add_elements_animation_queued(
	instance_id : int,
	added_element_names : Array[String]
) -> void:
	if not self.applicable(instance_id):
		return

	# possibly revisit this to do actual animation
	# if so, self.finish_adding_elements will be a tween_callback
	self.render_added_elements(added_element_names)  
	self.finish_adding_elements()

func _on_remove_elements_animation_queued(
	instance_id : int,
	remove_indexes : Array[int]
) -> void:
	if not self.applicable(instance_id):
		return

	var element_names_to_remove : Array[String] = []
	for i in self.element_names.size():
		if i in remove_indexes:
			element_names_to_remove.append(self.element_names[i])
	self.queue_element_aura_nodes_to_remove(element_names_to_remove)
	self.animate_remove_element_auras_from_queue()

func _on_reposition_elements_animation_queued(
	instance_id : int,
	old_element_names : Array[String],
	remove_indexes : Array[int],
	remain_indexes : Array[int]
) -> void:
	if not self.applicable(instance_id):
		return

	var reposition_dicts : Array[Dictionary] = []
	for i in remain_indexes.size():
		var reposition_dict : Dictionary = {}
		var remain_index = remain_indexes[i]
		var remain_element_name : String = old_element_names[remain_index]
		var num_same_removed_before : int = 0
		var num_diff_removed_before : int = 0
		for remove_index in remove_indexes:
			if remove_index < remain_index:
				var removed_element_name : String = old_element_names[remove_index]
				if remain_element_name == removed_element_name:
					num_same_removed_before += 1
				else:
					num_diff_removed_before += 1
		reposition_dict["new_index_position"] = i
		reposition_dict["num_same_removed_before"] = num_same_removed_before
		reposition_dict["num_diff_removed_before"] = num_diff_removed_before
		reposition_dict["element_name"] = old_element_names[remain_index]
		reposition_dicts.append(reposition_dict)

	self.queue_element_aura_nodes_to_reposition(reposition_dicts)
	self.animate_reposition_element_aura_from_queue()

#=======================
# Helpers
#=======================
func applicable(instance_id : int) -> bool:
	return instance_id == self.entity_instance_id

func render_added_elements(added_element_names : Array[String]) -> void:
	var num_elements : int = self.element_names.size()
	var render_index : int =  num_elements - added_element_names.size()
	for element_name in added_element_names:
		var new_unrendered_element : Element = Element.by_machine_name(element_name)
		var instance = self.instantiate_aura_element(new_unrendered_element)
		self.position_aura_element(instance, render_index)
		render_index += 1

func instantiate_aura_element(element : Element) -> Node2D:
	var instance = aura_element_scene.instantiate()
	instance.set("element", element)
	add_child(instance)
	return instance

func position_aura_element(instance : Node2D, position_index : int) -> void:
	var position_x = self.get_aura_element_position_x(instance, position_index)
	instance.position.x = position_x

func get_aura_element_position_x(instance : Node2D, position_index : int) -> int:
	var aura_element_width : int = instance.image_data.get_img_width()
	var starting_x : int = (-1 * int(self.aura_width / 2.0)) + int(aura_element_width / 2.0)
	var offset_x : int = (position_index * aura_element_width) + (position_index * 10)
	return starting_x + offset_x

func finish_adding_elements() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ADD_ELEMENTS_ANIMATION_FINISHED,
		self.entity_instance_id
	)

func queue_element_aura_nodes_to_remove(element_names_to_remove : Array[String]) -> void:
	var claimed_indexes : Array[int] = []
	var num_children = self.get_child_count()
	for element_name in element_names_to_remove:
		for i in num_children:
			if i in claimed_indexes:
				continue
			var child = self.get_child(i)
			var element = child.get("element")
			if element is Element and element.machine_name == element_name:
				self.remove_queue.enqueue(child)
				claimed_indexes.append(i)
				break

func animate_remove_element_aura_from_queue() -> void:
	var element_aura_node : Node2D = self.remove_queue.dequeue()
	self.free_queue.enqueue(element_aura_node)
	var tween = self.create_tween()
	var cur_position = element_aura_node.position
	tween.tween_property(
		element_aura_node,
		"position",
		Vector2(cur_position.x, cur_position.y - 50),
		0.5
	)
	tween.tween_callback(self.free_removed_element_aura_node)
	tween.tween_callback(self.check_remove_queue)

func animate_remove_element_auras_from_queue() -> void:
	var element_aura_nodes : Array[Node2D] = []
	while not self.remove_queue.is_empty():
		element_aura_nodes.append(self.remove_queue.dequeue())

	for element_aura_node in element_aura_nodes:
		self.free_queue.enqueue(element_aura_node)

	for element_aura_node in element_aura_nodes:
		var tween = create_tween()
		var cur_position = element_aura_node.position
		tween.tween_property(
			element_aura_node,
			"position",
			Vector2(cur_position.x, cur_position.y - 50),
			0.5
		)
		tween.tween_callback(self.free_removed_element_aura_node)

func free_removed_element_aura_node() -> void:
	var element_aura_node : Node2D = self.free_queue.dequeue()
	element_aura_node.queue_free()
	if self.free_queue.is_empty():
		self.emit_remove_elements_animation_finished()

func emit_remove_elements_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.REMOVE_ELEMENTS_ANIMATION_FINISHED,
		self.entity_instance_id
	)

func check_remove_queue() -> void:
	if not self.remove_queue.is_empty():
		self.animate_remove_element_aura_from_queue()
	else:
		BattleRadio.emit_signal(
			BattleRadio.REMOVE_ELEMENTS_ANIMATION_FINISHED,
			self.entity_instance_id
		)

func queue_element_aura_nodes_to_reposition(element_reposition_dicts : Array[Dictionary]) -> void:
	var claimed_indexes : Array[int] = []
	var num_children = self.get_child_count()
	for element_reposition_dict in element_reposition_dicts:
		var reposition_element_name : String = element_reposition_dict["element_name"]
		var num_same_removed_before : int = element_reposition_dict["num_same_removed_before"]
		var num_diff_removed_before : int = element_reposition_dict["num_diff_removed_before"]
		var num_same_element_visited : int = 0
		var num_diff_element_visited : int = 0
		for i in num_children:
			if i in claimed_indexes:
				continue
			var child = self.get_child(i)
			var element = child.get("element")
			if element is Element:
				if (num_same_element_visited == num_same_removed_before
					and num_diff_element_visited == num_diff_removed_before):
						element_reposition_dict["node"] = child
						self.reposition_queue.enqueue(element_reposition_dict)
						claimed_indexes.append(i)
						break

				if element.machine_name == reposition_element_name:
					num_same_element_visited += 1
				else:
					num_diff_element_visited += 1

func animate_reposition_element_aura_from_queue() -> void:
	var element_reposition_dict : Dictionary = self.reposition_queue.dequeue()
	var element_aura_node : Node2D = element_reposition_dict["node"]
	var new_index_position : int = element_reposition_dict["new_index_position"]
	var position_x = self.get_aura_element_position_x(
		element_aura_node,
		new_index_position
	)
	if position_x != element_aura_node.position.x:
		var tween = create_tween()
		tween.tween_property(
			element_aura_node,
			"position",
			Vector2(position_x, element_aura_node.position.y),
			0.5
		)
		tween.tween_callback(self.check_reposition_queue)

func check_reposition_queue() -> void:
	if not self.reposition_queue.is_empty():
		self.animate_reposition_element_aura_from_queue()
	else:
		BattleRadio.emit_signal(
			BattleRadio.REPOSITION_ELEMENTS_ANIMATION_FINISHED,
			self.entity_instance_id
		)
