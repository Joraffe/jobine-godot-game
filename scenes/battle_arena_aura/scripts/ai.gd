extends Node


var entity_type : String
var entity_instance_id : int
var element_names : Array[String] :
	set = set_element_names
var combiner : Combiner


var is_repositioning_finished : bool :
	set = set_is_repositioning_finished
var is_removing_finished : bool :
	set = set_is_removing_finished

var is_combo_effect_finished : bool :
	set = set_is_combo_effect_finished
var is_combo_bonus_effect_finished : bool :
	set = set_is_combo_bonus_effect_finished

var finished : bool


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
	BattleRadio.connect(BattleRadio.ADD_ELEMENTS_ANIMATION_FINISHED, _on_add_elements_animation_finished)
	BattleRadio.connect(BattleRadio.REMOVE_ELEMENTS_ANIMATION_FINISHED, _on_remove_elements_animation_finished)
	BattleRadio.connect(BattleRadio.REPOSITION_ELEMENTS_ANIMATION_FINISHED, _on_reposition_elements_animation_finished)
	BattleRadio.connect(BattleRadio.COMBO_ANIMATION_FINISHED, _on_combo_animation_finished)
	BattleRadio.connect(BattleRadio.COMBO_EFFECT_FINISHED, _on_combo_effect_finished)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_EFFECT_FINISHED, _on_combo_bonus_effect_finished)
	BattleRadio.connect(BattleRadio.COMBO_CHECK_DEFERRED, _on_combo_check_deferred)


#=======================
# Setters
#=======================
func set_element_names(new_element_names : Array[String]) -> void:
	element_names = new_element_names
	# this also calculates possible combos when created
	self.set("combiner", Combiner.new(self.element_names, self.entity_instance_id))

func set_is_repositioning_finished(new_is_repositioning_finished : bool) -> void:
	is_repositioning_finished = new_is_repositioning_finished
	if self.is_repositioning_finished:
		self.check_for_all_animations_finished()

func set_is_removing_finished(new_is_removing_finished : bool) -> void:
	is_removing_finished = new_is_removing_finished
	if self.is_removing_finished:
		self.check_for_all_animations_finished()

func set_is_combo_effect_finished(new_is_combo_effect_finished : bool) -> void:
	is_combo_effect_finished = new_is_combo_effect_finished
	if self.is_combo_effect_finished:
		self.check_for_all_effects_finished()

func set_is_combo_bonus_effect_finished(new_is_combo_bonus_effect_finished : bool) -> void:
	is_combo_bonus_effect_finished = new_is_combo_bonus_effect_finished
	if self.is_combo_bonus_effect_finished:
		self.check_for_all_effects_finished()


#=======================
# Signal Handlers
#=======================
func _on_add_elements_animation_finished(instance_id : int) -> void:
	if not self.applicable(instance_id):
		return

	if not self.combiner.has_combo():
		self.emit_elements_settled()
		return

	self.emit_remove_and_reposition_animations_queued()

func _on_remove_elements_animation_finished(instance_id : int) -> void:
	if not self.applicable(instance_id):
		return
	self.set("is_removing_finished", true)

func _on_reposition_elements_animation_finished(instance_id : int) -> void:
	if not self.applicable(instance_id):
		return

	self.set("is_repositioning_finished", true)

func _on_combo_animation_finished(instance_id : int) -> void:
	if not self.applicable(instance_id):
		return

	self.emit_combo_bonus_check_deffered(self.combiner)
	var group_name : String = self.get_group_name()
	self.emit_combo_effects_deferred_to_group(group_name, self.combiner)

func _on_combo_effect_finished(instance_id : int, finish_data : Dictionary) -> void:
	if not self.applicable(instance_id):
		return

	if finish_data.get("fainted_target") or finish_data.get("did_not_add_elements"):
		self.set("finished", true)

	self.set("is_combo_effect_finished", true)


func _on_combo_bonus_effect_finished(instance_id : int, finish_data : Dictionary) -> void:
	if not self.applicable(instance_id):
		return

	if finish_data.get("fainted_target") or finish_data.get("did_not_add_elements"):
		self.set("finished", true)

	self.set("is_combo_bonus_effect_resolved", true)

func _on_combo_check_deferred(instance_id : int) -> void:
	if not self.applicable(instance_id):
		return

	if not self.combiner.has_combo():
		self.emit_elements_settled()
		return

	self.emit_remove_and_reposition_animations_queued()


#=======================
# Helpers
#=======================
func applicable(instance_id : int) -> bool:
	return instance_id == self.entity_instance_id

func emit_elements_settled() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ELEMENTS_SETTLED,
		 self.entity_instance_id
	)

func emit_remove_and_reposition_animations_queued() -> void:
	BattleRadio.emit_signal(
		BattleRadio.REMOVE_ELEMENTS_ANIMATION_QUEUED,
		self.entity_instance_id,
		self.combiner.remove_indexes
	)

	if self.combiner.has_remaining_elements():
		BattleRadio.emit_signal(
			BattleRadio.REPOSITION_ELEMENTS_ANIMATION_QUEUED,
			self.entity_instance_id,
			self.combiner.element_names,
			self.combiner.remove_indexes,
			self.combiner.remaining_indexes
		)
	else:
		self.set("is_repositioning_finished", true)

func check_for_all_animations_finished() -> void:
	if self.is_removing_finished and self.is_repositioning_finished:
		self.set("is_removing_finished", false)
		self.set("is_repositioning_finished", false)
		if self.combiner.has_combo():
			BattleRadio.emit_signal(
				BattleRadio.COMBO_ANIMATION_QUEUED,
				self.entity_instance_id,
				self.combiner.current_combo
			)

func check_for_all_effects_finished() -> void:
	if self.is_combo_effect_finished and self.is_combo_bonus_effect_finished:
		BattleRadio.emit_signal(
			BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY,
			self.entity_instance_id,
			self.combiner.remove_indexes
		)
		# if we are finished, we can emit the "elements settled" event
		if self.finished:
			BattleRadio.emit_signal(BattleRadio.ELEMENTS_SETTLED)
			self.set("finished", false)
		# otherwise, we dont do anything because elsewhere
		# will emit another ELEMENT_APPLIED_TO_ENTITY signal
		# which will start the chain of signal handlers here

		self.set("is_combo_effect_finished", false)
		self.set("is_combo_bonus_effect_finished", false)

func defer_combo_bonus_check(combiner_to_defer : Combiner) -> void:
	self.emit_combo_bonus_check_deffered(combiner_to_defer)

func get_group_name() -> String:
	var group_name : String

	if self.is_entity_character():
		group_name = BattleConstants.GROUP_PARTY
	elif self.is_entity_enemy():
		group_name = BattleConstants.GROUP_ENEMIES

	return group_name

func is_entity_character() -> bool:
	return self.entity_type == BattleConstants.ENTITY_CHARACTER

func is_entity_enemy() -> bool:
	return self.entity_type in [
		BattleConstants.ENTITY_ENEMY,
		BattleConstants.ENTITY_BOSS
	]

func emit_combo_effects_deferred_to_group(group_name : String, combiner_to_defer : Combiner) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_EFFECTS_DEFERRED_TO_GROUP,
		group_name,
		combiner_to_defer,
		self.entity_instance_id
	)

func emit_combo_bonus_check_deffered(combiner_to_defer : Combiner) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_BONUS_CHECK_DEFERRED,
			combiner_to_defer,
			self.entity_instance_id,
	)
