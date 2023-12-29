extends Node2D


var status_effect_scene = preload(
	"res://scenes/battle_arena_status_effect/BattleArenaStatusEffect.tscn"
)

var entity : Variant :
	set = set_entity
var entity_image_width : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ADD_STATUS_EFFECT_ANIMATION_QUEUED, _on_add_status_effect_animation_queued)
	BattleRadio.connect(BattleRadio.REMOVE_STATUS_EFFECT_ANIMATION_QUEUED, _on_remove_status_effect_animation_queued)
	BattleRadio.connect(BattleRadio.REPOSITION_STATUS_EFFECT_ANIMATION_QUEUED, _on_reposition_status_effect_animation_queued)


#=======================
# Godot Lifecycle Hooks
#=======================
func set_entity(new_entity : Variant) -> void:
	entity = new_entity

	if self.entity.has_status_effects():
		for status_effect in self.entity.current_status_effects:
			self.animate_add_status_effect(status_effect)


#=======================
# Signal Handlers
#=======================
func _on_add_status_effect_animation_queued(
	instance_id : int,
	added_status_effect : StatusEffect
) -> void:
	if not self.is_applicable(instance_id):
		return
	
	self.animate_add_status_effect(added_status_effect)

func _on_remove_status_effect_animation_queued(
	instance_id : int,
	removed_status_effects : Array[StatusEffect]
) -> void:
	if not self.is_applicable(instance_id):
		return

	self.animate_remove_status_effects(removed_status_effects)

func _on_reposition_status_effect_animation_queued(
	instance_id : int,
	repositioned_status_effects : Array[StatusEffect]
) -> void:
	if not self.is_applicable(instance_id):
		return

	self.animate_reposition_status_effects(repositioned_status_effects)


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id == self.entity.get_instance_id()

func instantiate_status_effect(status_effect : StatusEffect) -> Node2D:
	var instance = status_effect_scene.instantiate()
	instance.set("status_effect", status_effect)
	self.add_child(instance)
	return instance

func position_status_effect(instance : Node2D, position_index : int) -> void:
	instance.position.x = self.get_position_x_for_index(instance, position_index)

func get_position_x_for_index(instance : Node2D, position_index : int) -> int:
	var status_effect_image_width : int = instance.image_data.get_img_width()
	var starting_x : int = (-1 * int(self.entity_image_width / 2.0)) + int(status_effect_image_width / 2.0)
	var offset_x : int = (position_index * status_effect_image_width) + (position_index * 10)
	return starting_x + offset_x

func animate_add_status_effect(added_status_effect : StatusEffect) -> void:
	var added_index : int = self.entity.current_status_effects.find(added_status_effect)
	var added_instance : Node2D = self.instantiate_status_effect(added_status_effect)
	# possibly sub this out for a proper animation in the future
	self.position_status_effect(added_instance, added_index)
	# if we have a proper animation in the future, this emit will be a callback instead
	self.emit_add_status_effect_animation_finished()

func animate_remove_status_effects(removed_status_effects : Array[StatusEffect]) -> void:
	for removed_status_effect in removed_status_effects:
		for child in self.get_children():
			if child.get("status_effect") == removed_status_effect:
				# possibly sub this out for a proper animation in the future
				child.queue_free()
	# if we have a proper animation in the future, this emit will be a callback instead
	self.emit_remove_status_effect_animation_finished()

func animate_reposition_status_effects(repositioned_status_effects : Array[StatusEffect]) -> void:
	for repositioned_status_effect in repositioned_status_effects:
		var reposition_index : int = self.entity.current_status_effects.find(repositioned_status_effect)
		for child in self.get_children():
			if child.get("status_effect") == repositioned_status_effect:
				# possibly sub this out for a proper animation in the future
				self.position_status_effect(child, reposition_index)
	# if we have a proper animation in the future, this emit will be a callback instead
	self.emit_reposition_status_effect_animation_finished()

func emit_add_status_effect_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ADD_STATUS_EFFECT_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)

func emit_remove_status_effect_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.REMOVE_STATUS_EFFECT_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)

func emit_reposition_status_effect_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.REPOSITION_ELEMENTS_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)
