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


# -> element applied to entity
# -> add element animation queued
# -> add element animation finished
# -> check for combo queued
# -> if not combo:
# ----> element applied finished 
# -> else if combo:
# ----> remove combined elements animation queued + reposition remaining elements animation queued
# ----> remove combined element animation finished + reposition remaining elements animation finished
# -> elements removed from entity queued
# -> elements removed from entity finished
# -> combo animation queued
# -> combo animation finished
# -> combo effect queued + combo bonus effect queued
# -> combo effect resolved + combo effect resolved
# -> if combo/combo bonus faints the target:
# ----> combo/combo bonus effect finished
# -> if combo/combo bonus adds elements:
# ----> element applied to entity (go back to beginning)
# -> else:
# ----> combo/combo bonus effect finished
# -> element applied finished



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

	print('_on_add_elements_animation_queued')
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

	print('_on_remove_elements_animation_queued called')
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
	
	print('_on_reposition_elements_animation_queued called')
	var reposition_dicts : Array[Dictionary] = []
	for i in remain_indexes.size():
		var reposition_dict : Dictionary = {}
		var remain_index = remain_indexes[i]
		var num_removed_before_remain_index : int = 0
		for remove_index in remove_indexes:
			if remove_index < remain_index:
				num_removed_before_remain_index += 1
		reposition_dict["new_index_position"] = i
		reposition_dict["num_removed_before_remain_index"] = num_removed_before_remain_index
		reposition_dict["element_name"] = old_element_names[remain_index]
		reposition_dicts.append(reposition_dict)

	print('reposition_dicts ', reposition_dicts)
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
	print('position_aura_element called')
	var position_x = self.get_aura_element_position_x(instance, position_index)
	print('position_x ', position_x)
	instance.position.x = position_x

func get_aura_element_position_x(instance : Node2D, position_index : int) -> int:
	print('get_aura_element_position_x called')
	var aura_element_width : int = instance.image_data.get_img_width()
	var starting_x : int = (-1 * int(self.aura_width / 2.0)) + int(aura_element_width / 2.0)
	var offset_x : int = (position_index * aura_element_width) + (position_index * 10)
	return starting_x + offset_x

func finish_adding_elements() -> void:
	print('finish_adding_elements')
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
	print('emit_remove_elements_animation_finished called')
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
	print('queue_element_aura_nodes_to_reposition called')
	var claimed_indexes : Array[int] = []
	var num_children = self.get_child_count()
	print('num_children ', num_children)
	for element_reposition_dict in element_reposition_dicts:
		var reposition_element_name : String = element_reposition_dict["element_name"]
		var num_removed_before : int = element_reposition_dict["num_removed_before_remain_index"]
		var num_same_element_visited : int = 0
		for i in num_children:
			if i in claimed_indexes:
				continue
			var child = self.get_child(i)
			var element = child.get("element")
			if element is Element and element.machine_name == reposition_element_name:
				if num_removed_before - num_same_element_visited != 0:
					num_same_element_visited += 1
				else:
					element_reposition_dict["node"] = child
					self.reposition_queue.enqueue(element_reposition_dict)
					claimed_indexes.append(i)
					break

func animate_reposition_element_aura_from_queue() -> void:
	print('animate_reposition_element_aura_from_queue called')
	var element_reposition_dict : Dictionary = self.reposition_queue.dequeue()
	var element_aura_node : Node2D = element_reposition_dict["node"]
	var new_index_position : int = element_reposition_dict["new_index_position"]
	print('new_index_position ', new_index_position)
	var position_x = self.get_aura_element_position_x(
		element_aura_node,
		element_reposition_dict["new_index_position"]
	)
	print('position_x ', position_x)
	print('element_aura_node.position.x ', element_aura_node.position.x)
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
