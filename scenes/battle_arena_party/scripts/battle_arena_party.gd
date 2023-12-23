extends Node2D


var party_lead_character : Character :
	set = set_party_lead_character
var party_standby_top_character : Character :
	set = set_party_standby_top_character
var party_standby_bottom_character : Character :
	set = set_party_standby_bottom_character

var party_targeter : Targeter
var current_combiner : Combiner

var current_combos : Array[int]
var current_combo_targets : Array[int]
var current_combo_bonus_instance_id : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.STANDBY_SWAP_TO_LEAD_QUEUED, _on_standby_swap_to_lead_queued)
	BattleRadio.connect(BattleRadio.COMBO_EFFECTS_DEFERRED_TO_GROUP, _on_combo_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_EFFECTS_DEFERRED_TO_GROUP, _on_combo_bonus_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)
	BattleRadio.connect(BattleRadio.SELF_NON_TARGETING_COMBO_BONUS_APPLIED, _on_self_non_targeting_combo_bonus_applied)
	BattleRadio.connect(BattleRadio.ENTITY_FAINED, _on_entity_fainted)
	BattleRadio.connect(BattleRadio.ENTITY_DEFEATED_ANIMATION_FINISHED, _on_entity_defeated_animation_finished)


#=======================
# Setters
#=======================
func set_party_lead_character(new_character : Character) -> void:
	party_lead_character = new_character
	$PartyLead.set("lead_character", self.party_lead_character)

func set_party_standby_top_character(new_character : Character) -> void:
	party_standby_top_character = new_character
	$PartyStandby.set("standby_top_character", self.party_standby_top_character)

func set_party_standby_bottom_character(new_character : Character) -> void:
	party_standby_bottom_character = new_character
	$PartyStandby.set("standby_bottom_character", self.party_standby_bottom_character)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("party_lead_character", battle_data.lead_character)
	self.set("party_standby_top_character", battle_data.top_swap_character)
	self.set("party_standby_bottom_character", battle_data.bottom_swap_character)
	var party_instance_ids : Array[int] = self.get_party_instance_ids()
	$Effector.set("entity_instance_ids", party_instance_ids)

func _on_standby_swap_to_lead_queued(standby_instance_id : int) -> void:
	self.swap_standby_to_lead(standby_instance_id)
	self.emit_standby_swap_to_lead_finished()

func _on_combo_effects_deferred_to_group(
	group_name : String,
	combiner : Combiner,
	primary_target_instance_id : int
) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("current_combiner", combiner)
	var combo : Combo = combiner.current_combo
	var current_combo_instance_id : int = combo.get_instance_id()
	self.current_combos.append(current_combo_instance_id)
	self.current_combo_targets.append(primary_target_instance_id)
	self.set(
		"party_targeter",
		Targeter.new(
			combo.targeting_name,
			self.get_party_instance_ids(),
			primary_target_instance_id
		)
	)

	var all_combo_effects : Array[Dictionary] = []
	var target_instance_ids : Array[int] = self.party_targeter.instance_ids()
	for target_instance_id in target_instance_ids:
		var target_combo_effects : Array[Dictionary] = combo.get_sequential_effects(target_instance_id)
		all_combo_effects += target_combo_effects

	self.emit_effects_enqueued(
		current_combo_instance_id,
		primary_target_instance_id,
		all_combo_effects
	)
	self.emit_remove_elements_from_current_combiner(primary_target_instance_id)
	self.emit_next_effect_queued(primary_target_instance_id)

func _on_combo_bonus_effects_deferred_to_group(
	group_name : String,
	combo_bonus : ComboBonus,
	primary_target_instance_id : int
) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("current_combo_bonus_instance_id", combo_bonus.get_instance_id())
	self.set(
		"party_targeter",
		Targeter.new(
			combo_bonus.targeting_name,
			self.get_party_instance_ids(),
			primary_target_instance_id
		)
	)
	var all_combo_bonus_effects : Array[Dictionary] = []
	var target_instance_ids : Array[int] = self.party_targeter.instance_ids()
	for target_instance_id in target_instance_ids:
		var target_combo_bonus_effects : Array[Dictionary] = combo_bonus.get_sequential_effects(target_instance_id)
		all_combo_bonus_effects += target_combo_bonus_effects
	self.emit_effects_enqueued(
		self.current_combo_bonus_instance_id,
		primary_target_instance_id,
		all_combo_bonus_effects
	)
	self.emit_next_effect_queued(primary_target_instance_id)

func _on_effects_finished(effector_instance_id : int) -> void:
	if effector_instance_id not in self.current_combos:
		return

	var combo_index : int
	var remaining_current_combos : Array[int] = []
	for i in self.current_combos.size():
		var instance_id : int = self.current_combos[i]
		if not instance_id == effector_instance_id:
			remaining_current_combos.append(instance_id)
		elif instance_id == effector_instance_id:
			combo_index = i
	self.set("current_combos", remaining_current_combos)

	var combo_target_instance_id : int
	var remaining_combo_targets : Array[int] = []
	for i in self.current_combo_targets.size():
		if i != combo_index:
			remaining_combo_targets.append(self.current_combo_targets[i])
		elif i == combo_index:
			combo_target_instance_id = self.current_combo_targets[i]
	self.set("current_combo_targets", remaining_combo_targets)

	BattleRadio.emit_signal(
		BattleRadio.COMBO_CHECK_DEFERRED,
		combo_target_instance_id
	)

func _on_self_non_targeting_combo_bonus_applied(combo_bonus : ComboBonus) -> void:
	if combo_bonus.is_extra_energy():
		self.emit_combo_bonus_energy_gained(combo_bonus)
		return

	if combo_bonus.is_extra_swap():
		self.emit_combo_bonus_swaps_gained(combo_bonus)
		return

	if combo_bonus.is_extra_cards():
		self.emit_combo_bonus_cards_gained(combo_bonus)
		return

func _on_entity_fainted(fainted_instance_id : int) -> void:
	if not self.is_applicable(fainted_instance_id):
		return

	self.emit_entity_defeated_animation_queued(fainted_instance_id)

func _on_entity_defeated_animation_finished(fainted_instance_id : int) -> void:
	if not self.is_applicable(fainted_instance_id):
		return

	if fainted_instance_id == self.party_lead_character.get_instance_id():
		var next_lead_character : Character = self.get_next_lead_character()
		# if there's not a lead character, it's a game over!
		if not next_lead_character:
			self.emit_battle_lost()
			return

		self.swap_standby_to_lead(next_lead_character.get_instance_id())
		self.emit_standby_swap_to_lead_finished()
		self.emit_faint_settled(fainted_instance_id)


#========================
# Helpers
#========================
func is_standby_top(instance_id : int) -> bool:
	return instance_id == self.party_standby_top_character.get_instance_id()

func is_standby_bottom(instance_id : int) -> bool:
	return instance_id == self.party_standby_bottom_character.get_instance_id()

func get_party_instance_ids() -> Array[int]:
	var instance_ids : Array[int] = [
		self.party_standby_top_character.get_instance_id(),
		self.party_lead_character.get_instance_id(),
		self.party_standby_bottom_character.get_instance_id()
	]
	return instance_ids

func is_applicable(instance_id : int) -> bool:
	return instance_id in self.get_party_instance_ids()

func get_standby_character_queue() -> Queue:
	var standby_characters : Queue = Queue.new()

	standby_characters.enqueue(self.party_standby_top_character)
	standby_characters.enqueue(self.party_standby_bottom_character)

	return standby_characters

func get_next_lead_character() -> Character:
	var next_lead_character : Character

	var standby_character_queue : Queue = self.get_standby_character_queue()
	while not standby_character_queue.is_empty():
		var standby_character : Character = standby_character_queue.dequeue()
		if not standby_character.has_fainted():
			next_lead_character = standby_character
			break

	return next_lead_character

func swap_standby_to_lead(standby_instance_id : int) -> void:
	var old_lead : Character = self.party_lead_character
	var swapping_standby : Character
	var swapping_standby_key : String
	if self.is_standby_top(standby_instance_id):
		swapping_standby = self.party_standby_top_character
		swapping_standby_key = "party_standby_top_character"
	elif self.is_standby_bottom(standby_instance_id):
		swapping_standby = self.party_standby_bottom_character
		swapping_standby_key = "party_standby_bottom_character"

	self.set("party_lead_character", swapping_standby)
	self.set(swapping_standby_key, old_lead)

func emit_standby_swap_to_lead_finished() -> void:
	BattleRadio.emit_signal(BattleRadio.STANDBY_SWAP_TO_LEAD_FINISHED)

func emit_effects_enqueued(
	effector_instance_id : int,
	target_instance_id : int,
	effects : Array[Dictionary]
) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		effector_instance_id,
		target_instance_id,
		effects
	)

func emit_next_effect_queued(target_instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		target_instance_id
	)

func emit_remove_elements_from_current_combiner(target_instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY,
		target_instance_id,
		self.current_combiner.remove_indexes
	)

func emit_combo_bonus_energy_gained(combo_bonus : ComboBonus) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_BONUS_ENERGY_GAINED,
		combo_bonus.energy_amount
	)

func emit_combo_bonus_swaps_gained(combo_bonus : ComboBonus) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_BONUS_SWAPS_GAINED,
		combo_bonus.swap_amount
	)

func emit_combo_bonus_cards_gained(combo_bonus : ComboBonus) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_BONUS_CARDS_GAINED,
		combo_bonus.card_draw_amount
	)

func emit_faint_settled(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.FAINT_SETTLED,
		instance_id
	)

func emit_battle_lost() -> void:
	BattleRadio.emit_signal(BattleRadio.BATTLE_LOST)
 
func emit_entity_defeated_animation_queued(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_DEFEATED_ANIMATION_QUEUED,
		instance_id
	)
