extends Node


var entity_instance_ids : Array[int] :
	set = set_entity_instance_ids

var identifier : Identifier
var effect_queue : Queue = Queue.new()
var element_effect_queue : Queue = Queue.new()
var effector_stack : Stack = Stack.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.EFFECTS_ENQUEUED, _on_effects_enqueued)
	BattleRadio.connect(BattleRadio.NEXT_EFFECT_QUEUED, _on_next_effect_queued)
	BattleRadio.connect(BattleRadio.EFFECT_RESOLVED, _on_effect_resolved)
	BattleRadio.connect(BattleRadio.ELEMENTS_SETTLED, _on_elements_settled)


#=======================
# Setters
#=======================
func set_entity_instance_ids(new_ids : Array[int]) -> void:
	entity_instance_ids = new_ids
	self.set("identifier", Identifier.new(self.entity_instance_ids))


#=======================
# Signal Handlers
#=======================
func _on_effects_enqueued(
	effector_instance_id : int,
	target_instance_id : int,
	effects : Array[Dictionary]
) -> void:
	if not self.identifier.is_applicable(target_instance_id):
		return

	self.effector_stack.push(effector_instance_id)
	for effect in effects:
		self.effect_queue.enqueue(effect)

func _on_next_effect_queued(instance_id : int) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.emit_next_effect()

func _on_effect_resolved(instance_id : int, resolve_data : Dictionary) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	var effect_type : String = resolve_data[BattleConstants.EFFECT_TYPE]
	var result : String = resolve_data[BattleConstants.EFFECT_RESULT]

	if self.is_damage_effect(effect_type) and self.is_result_fainted(result):
		var effector_instance_id : int = self.effector_stack.pop()
		self.effect_queue.empty()
		self.emit_effect_finished(effector_instance_id)
		return

	# if there are more effects, continue emitting those effects
	if not self.effect_queue.is_empty():
		self.emit_next_effect()
		return

	# otherwise we've finished:
	var effector_instance_id : int = self.effector_stack.pop()
	self.emit_effect_finished(effector_instance_id)

func _on_elements_settled(instance_id : int) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	if not self.effect_queue.is_empty():
		self.emit_next_effect()
		return

	while not self.effector_stack.is_empty():
		var effector_instance_id : int = self.effector_stack.pop()
		self.emit_effect_finished(effector_instance_id)


#=======================
# Helpers
#=======================
func is_damage_effect(effect_type : String) -> bool:
	return effect_type == BattleConstants.DAMAGE_EFFECT

func is_element_effect(effect_type : String) -> bool:
	return effect_type == BattleConstants.ELEMENT_EFFECT

func should_damage_effect_bail(result : String):
	return self.is_result_fainted(result)

func is_result_fainted(result : String) -> bool:
	return result == BattleConstants.FAINTED

func emit_next_effect() -> void:
	var effect_data : Dictionary = self.effect_queue.dequeue()
	var effect_type : String = effect_data[BattleConstants.EFFECT_TYPE]
	if self.is_damage_effect(effect_type):
		self.emit_entity_damaged(effect_data)
		return

	# if we're applying an element, we'll need to wait for potential combos
	# before starting the next enemy attack (since element effects are last)
	if self.is_element_effect(effect_type):
		self.emit_element_applied_to_entity(effect_data)
		return

func emit_entity_damaged(effect_data : Dictionary) -> void:
	var effector_instance_id : int = effect_data[BattleConstants.EFFECTOR_INSTANCE_ID]
	var target_instance_id : int = effect_data[BattleConstants.TARGET_INSTANCE_ID]
	var damage : int = effect_data[BattleConstants.EFFECT_AMOUNT]
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_DAMAGED_BY_EFFECT,
		effector_instance_id,
		target_instance_id,
		damage
	)

func emit_element_applied_to_entity(effect_data : Dictionary) -> void:
	var effector_instance_id : int = effect_data[BattleConstants.EFFECTOR_INSTANCE_ID]
	var target_instance_id : int = effect_data[BattleConstants.TARGET_INSTANCE_ID]
	var element_name : String = effect_data[BattleConstants.EFFECT_NAME]
	var num_elements : int = effect_data[BattleConstants.EFFECT_AMOUNT]

	BattleRadio.emit_signal(
		BattleRadio.ADD_ELEMENTS_TO_ENTITY_BY_EFFECT,
		effector_instance_id,
		target_instance_id,
		element_name,
		num_elements
	)

func emit_effect_finished(effector_instance_id : int) -> void:
	BattleRadio.emit_signal(BattleRadio.EFFECTS_FINISHED, effector_instance_id)
