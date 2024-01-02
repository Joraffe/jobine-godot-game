extends Node2D


var entity : Variant :
	set = set_entity

var entity_image_height : int :
	set = set_entity_image_height
var entity_image_width : int :
	set = set_entity_image_width


#=======================
# Setters
#=======================
func set_entity(new_entity : Variant) -> void:
	entity = new_entity

	self.entity.connect(BattleConstants.STATUS_EFFECT_DURATION_UPDATED, _on_current_status_effect_duration_updated)
	self.entity.connect(BattleConstants.NEW_STATUS_EFFECT_ADDED, _on_new_status_effect_added)
	self.entity.connect(BattleConstants.NEW_STATUS_EFFECT_NOT_ADDED, _on_new_status_effect_no_added)
	self.entity.connect(BattleConstants.STATUS_EFFECTS_REMOVED, _on_status_effects_removed)
	self.entity.connect(BattleConstants.STATUS_EFFECTS_REMAINED, _on_status_effects_remained)

	$Display.set("entity", self.entity)

func set_entity_image_height(new_image_height : int) -> void:
	entity_image_height = new_image_height

	self.position_status_effects()

func set_entity_image_width(new_image_width : int) -> void:
	entity_image_width = new_image_width

	$Display.set("entity_image_width", entity_image_width)


#=======================
# Signal Handlers
#=======================
func _on_current_status_effect_duration_updated(
	status_effect_instance_id : int,
	new_duration : int
) -> void:
	BattleRadio.emit_signal(
		BattleRadio.STATUS_EFFECT_DURATION_UPDATED,
		status_effect_instance_id,
		new_duration
	)

func _on_new_status_effect_added(new_status_effect : StatusEffect) -> void:
	self.emit_add_status_effect_animation_queued(new_status_effect)

func _on_new_status_effect_no_added(_new_status_effect_name : String) -> void:
	# skip the add animation to go to the next effect
	self.emit_add_status_effect_animation_finished()

func _on_status_effects_removed(removed_status_effects : Array[StatusEffect]) -> void:
	self.emit_remove_status_effect_animation_queued(removed_status_effects)

func _on_status_effects_remained(remained_status_effects : Array[StatusEffect]) -> void:
	self.emit_reposition_status_effect_animation_queued(remained_status_effects)


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id == self.entity.get_instance_id()

func position_status_effects() -> void:
	self.position.y = int(self.entity_image_height / 2.0) + 90

func emit_add_status_effect_animation_queued(added_status_effect : StatusEffect) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ADD_STATUS_EFFECT_ANIMATION_QUEUED,
		self.entity.get_instance_id(),
		added_status_effect
	)

func emit_add_status_effect_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ADD_STATUS_EFFECT_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)

func emit_remove_status_effect_animation_queued(removed : Array[StatusEffect]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.REMOVE_STATUS_EFFECT_ANIMATION_QUEUED,
		self.entity.get_instance_id(),
		removed
	)

func emit_reposition_status_effect_animation_queued(repositioned : Array[StatusEffect]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.REPOSITION_STATUS_EFFECT_ANIMATION_QUEUED,
		self.entity.get_instance_id(),
		repositioned
	)
