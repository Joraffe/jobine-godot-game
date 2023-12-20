extends Node2D


var party_lead_character : Character :
	set = set_party_lead_character
var party_standby_top_character : Character :
	set = set_party_standby_top_character
var party_standby_bottom_character : Character :
	set = set_party_standby_bottom_character

var party_targeter : Targeter
var current_combiner : Combiner
var current_combo_instance_id : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.STANDBY_SWAP_TO_LEAD_QUEUED, _on_standby_swap_to_lead_queued)
	BattleRadio.connect(BattleRadio.COMBO_EFFECTS_DEFERRED_TO_GROUP, _on_combo_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)


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
	self.emit_standby_swap_to_lead_finished()


func _on_combo_effects_deferred_to_group(group_name : String, combiner : Combiner) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	print('_on_combo_effects_deferred_to_group')
	var primary_target_instance_id : int = self.party_lead_character.get_instance_id()
	self.set("current_combiner", combiner)
	var combo : Combo = combiner.current_combo
	self.set("current_combo_instance_id", combo.get_instance_id())
	party_targeter = Targeter.new(
		combo.targeting_name,
		self.get_party_instance_ids(),
		primary_target_instance_id
	)
	var all_combo_effects : Array[Dictionary] = []
	var target_instance_ids : Array[int] = party_targeter.instance_ids()
	for target_instance_id in target_instance_ids:
		var target_combo_effects : Array[Dictionary] = combo.get_sequential_effects(target_instance_id)
		all_combo_effects += target_combo_effects
	print('all_combo_effects ', all_combo_effects)
	self.emit_effects_enqueued(
		self.current_combo_instance_id,
		primary_target_instance_id,
		all_combo_effects
	)
	self.emit_remove_elements_from_current_combiner(primary_target_instance_id)
	self.emit_next_effect_queued(primary_target_instance_id)

func _on_effects_finished(effector_instance_id : int) -> void:
	if self.current_combo_instance_id != effector_instance_id:
		return

	print('_on_effects_finished called')
#	BattleRadio.emit_signal(
#		BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY,
#		self.party_lead_character.get_instance_id(),
#		current_combiner.remove_indexes
#	)


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
	print('emit_remove_elements_from_current_combiner')
	BattleRadio.emit_signal(
		BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY,
		target_instance_id,
		self.current_combiner.remove_indexes
	)
