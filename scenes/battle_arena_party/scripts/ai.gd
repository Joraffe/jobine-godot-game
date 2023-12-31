extends Node


var party_lead_character : Character
var party_standby_top_character : Character
var party_standby_bottom_character : Character

var party_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.CHECK_PARTY_END_TURN_EFFECTS_DEFERRED, _on_check_party_end_turn_effects_deferred)
	BattleRadio.connect(BattleRadio.END_TURN_ANIMATION_FINISHED, _on_end_turn_animation_finished)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)

func _ready() -> void:
	$NextDelayTimer.connect("timeout", _on_next_delay_timer)
	$EndDelayTimer.connect("timeout", _on_end_delay_timer)


#=======================
# Signal Handlers
#=======================
func _on_check_party_end_turn_effects_deferred() -> void:
	self.enqueue_party_members()

	if self.party_queue.is_empty():
		$EndDelayTimer.start()
		return

	$NextDelayTimer.start()

func _on_end_turn_animation_finished(instance_id : int) -> void:
	if not self.is_applicable(instance_id):
		return

	self.emit_next_effect_queued(instance_id)

func _on_effects_finished(effector_instance_id : int) -> void:
	if not self.is_effector_instance_id_applicable(effector_instance_id):
		return

	if not self.party_queue.is_empty():
		$NextDelayTimer.start()
		return

	$EndDelayTimer.start()

func _on_next_delay_timer() -> void:
	var party_member : Character = self.party_queue.dequeue()

	if self.has_end_turn_effects(party_member):
		self.emit_end_effects_enqueued_for(party_member)

	if self.has_reduceable_status_effects(party_member):
		self.emit_reduce_effects_enqueued_for(party_member)

	if self.has_end_turn_animation(party_member):
		self.emit_end_turn_animation_queued(party_member)
	else:
		self.emit_next_effect_queued(party_member.get_instance_id())

func _on_end_delay_timer() -> void:
	self.emit_check_party_end_turn_effects_finished()


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id in [
		self.party_lead_character.get_instance_id(),
		self.party_standby_top_character.get_instance_id(),
		self.party_standby_bottom_character.get_instance_id()
	]

func is_effector_instance_id_applicable(effector_instance_id : int) -> bool:
	return effector_instance_id == self.get_instance_id()

func has_end_turn_animation(party_member : Character) -> bool:
	return party_member.has_end_turn_animation()

func has_end_turn_effects(party_member : Character) -> bool:
	return party_member.has_any_status_effect_removal_effects()

func has_reduceable_status_effects(party_member : Character) -> bool:
	return party_member.has_reduceable_status_effects()

func has_any_effects(party_member : Character) -> bool:
	return (
		self.has_end_turn_effects(party_member)
		or self.has_reduceable_status_effects(party_member)
	)

func get_animation_data_for(effect_name : String) -> Dictionary:
	return {
		"animation_name" : effect_name
	}

func enqueue_party_members() -> void:
	if self.has_any_effects(self.party_lead_character):
		self.party_queue.enqueue(self.party_lead_character)

	if self.has_any_effects(self.party_standby_top_character):
		self.party_queue.enqueue(self.party_standby_top_character)

	if self.has_any_effects(self.party_standby_bottom_character):
		self.party_queue.enqueue(self.party_standby_bottom_character)

func emit_end_effects_enqueued_for(party_member : Character) -> void:
	self.emit_end_effects_enqueued(
		party_member.get_instance_id(),
		party_member.get_sequential_status_effect_removal_effects(
			self.get_instance_id()
		)
	)

func emit_reduce_effects_enqueued_for(party_member : Character) -> void:
	var status_effects_to_reduce : Array[StatusEffect] = party_member.get_reducable_status_effects()
	var reduce_effects : Array[Dictionary] = []
	for status_effect in status_effects_to_reduce:
		reduce_effects.append(
			status_effect.get_reduce_effect(
				self.get_instance_id(),
				party_member.get_instance_id()
			)
		)
	self.emit_reduce_effects_enqueued(party_member, reduce_effects)

func emit_end_turn_animation_queued(party_member : Character) -> void:
	BattleRadio.emit_signal(
		BattleRadio.END_TURN_ANIMATION_QUEUED,
		party_member.get_instance_id(),
		party_member.get_end_turn_animation_name()
	)

func emit_reduce_effects_enqueued(party_member : Character, reduce_effects : Array[Dictionary]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		party_member.get_instance_id(),
		reduce_effects
	)

func emit_check_party_end_turn_effects_finished() -> void:
	BattleRadio.emit_signal(BattleRadio.CHECK_PARTY_END_TURN_EFFECTS_FINISHED)

func emit_end_effects_enqueued(instance_id : int, end_effects : Array[Dictionary]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		instance_id,
		end_effects
	)

func emit_next_effect_queued(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		instance_id
	)
