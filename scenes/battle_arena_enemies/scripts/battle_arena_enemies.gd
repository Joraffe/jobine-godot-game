extends Node2D


var enemies : Array[Enemy] :
	set = set_enemies
var enemy_instance_ids : Array[int]
var lead_instance_id : int :
	set = set_lead_instance_id

var enemies_targeter : Targeter

var current_card_instance_id : int
var current_card_primary_target_instance_id : int

var current_combiner : Combiner

var current_combos : Array[int]
var current_combo_targets : Array[int]

var current_combo_bonus_instance_id : int

var image_data : ImageData = ImageData.new(
	"battle_arena_enemies",
	"empty",
	"enemies.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CURRENT_LEAD_UPDATED, _on_current_lead_updated)
	BattleRadio.connect(BattleRadio.CARD_EFFECTS_DEFERRED_TO_GROUP, _on_card_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.COMBO_EFFECTS_DEFERRED_TO_GROUP, _on_combo_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_EFFECTS_DEFERRED_TO_GROUP, _on_combo_bonus_effects_deferred_to_group)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)
	BattleRadio.connect(BattleRadio.ENTITY_FAINED, _on_entity_fainted)
	BattleRadio.connect(BattleRadio.ENEMY_DEFEATED_ANIMATION_FINISHED, _on_enemy_defeated_animation_finished)


#=======================
# Setters
#=======================
func set_enemies(new_enemies : Array[Enemy]) -> void:
	enemies = new_enemies

	var instance_ids : Array[int] = []
	for enemy in self.enemies:
		instance_ids.append(enemy.get_instance_id())
	self.set("enemy_instance_ids", instance_ids)
	$Effector.set("entity_instance_ids", instance_ids)

func set_lead_instance_id(new_lead_instance_id : int) -> void:
	lead_instance_id = new_lead_instance_id
	$AI.set("lead_instance_id" , self.lead_instance_id)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("enemies", battle_data.enemies)
	self.set("lead_instance_id", battle_data.lead_character.get_instance_id())
	$Area2D.render_enemies()

func _on_current_lead_updated(new_lead : Character) -> void:
	self.set("lead_instance_id", new_lead.get_instance_id())

func _on_card_effects_deferred_to_group(
	group_name : String,
	card : Card,
	primary_target_instance_id : int
) -> void:
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	self.set(
		"enemies_targeter",
		Targeter.new(
			card.targeting_name,
			self.enemy_instance_ids,
			primary_target_instance_id
		)
	)
	self.set("current_card_instance_id", card.get_instance_id())
	self.set("current_card_primary_target_instance_id", primary_target_instance_id)
	var card_effect_instance_ids : Array[int] = self.enemies_targeter.instance_ids()
	var all_card_effects : Array[Dictionary] = []
	for instance_id in card_effect_instance_ids:
		var card_effects : Array[Dictionary] = card.get_sequential_effects(instance_id)
		all_card_effects += card_effects
	self.emit_effects_enqueued(
		self.current_card_instance_id,
		primary_target_instance_id,
		all_card_effects
	)
	self.emit_next_effect_queued(primary_target_instance_id)

func _on_combo_effects_deferred_to_group(
	group_name : String,
	combiner : Combiner,
	primary_target_instance_id : int
) -> void:
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	self.set("current_combiner", combiner)
	var combo : Combo = combiner.current_combo
	var current_combo_instance_id : int = combo.get_instance_id()
	self.current_combos.append(current_combo_instance_id)
	self.current_combo_targets.append(primary_target_instance_id)
	self.set(
		"enemies_targeter",
		Targeter.new(
			combo.targeting_name,
			self.enemy_instance_ids,
			primary_target_instance_id
		)
	)
	var all_combo_effects : Array[Dictionary] = []
	var target_instance_ids : Array[int] = self.enemies_targeter.instance_ids()
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
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	self.set("current_combo_bonus_instance_id", combo_bonus.get_instance_id())
	self.set(
		"enemies_targeter",
		Targeter.new(
			combo_bonus.targeting_name,
			self.enemy_instance_ids,
			primary_target_instance_id
		)
	)
	var all_combo_bonus_effects : Array[Dictionary] = []
	var target_instance_ids : Array[int] = self.enemies_targeter.instance_ids()
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

func _on_entity_fainted(instance_id : int) -> void:
	if not self.is_instance_id_applicable(instance_id):
		return

	self.emit_enemy_defeated_animation_queued(instance_id)

func _on_enemy_defeated_animation_finished(instance_id : int) -> void:
	if not self.is_instance_id_applicable(instance_id):
		return

	self.set("enemies", self.filter_enemy_instance_id(instance_id))

#======================
# Helpers
#======================
func is_instance_id_applicable(instance_id : int) -> bool:
	for enemy in self.enemies:
		if enemy.get_instance_id() == instance_id:
			return true

	return false

func filter_enemy_instance_id(instance_id : int) -> Array[Enemy]:
	var new_enemies : Array[Enemy] = []

	for enemy in self.enemies:
		if not enemy.get_instance_id() == instance_id:
			new_enemies.append(enemy)

	return new_enemies

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

func emit_enemy_defeated_animation_queued(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_DEFEATED_ANIMATION_QUEUED,
		instance_id
	)
