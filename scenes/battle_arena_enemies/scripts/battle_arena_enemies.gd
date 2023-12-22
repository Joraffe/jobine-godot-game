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
var current_combo_instance_id : int

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
	$Area2D.render_enemies()

func set_lead_instance_id(new_lead_instance_id : int) -> void:
	lead_instance_id = new_lead_instance_id
	$AI.set("lead_instance_id" , self.lead_instance_id)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("enemies", battle_data.enemies)
	self.set("lead_instance_id", battle_data.lead_character.get_instance_id())

func _on_current_lead_updated(new_lead_instance_id : int) -> void:
	self.set("lead_instance_id", new_lead_instance_id)

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

func _on_combo_effects_deferred_to_group(group_name : String, combiner : Combiner) -> void:
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	var primary_target_instance_id : int = self.current_card_primary_target_instance_id
	self.set("current_combiner", combiner)
	var combo : Combo = combiner.current_combo
	self.set("current_combo_instance_id", combo.get_instance_id())
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
		self.current_combo_instance_id,
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


#======================
# Helpers
#======================
func is_instance_id_applicable(instance_id : int) -> bool:
	for enemy in self.enemies:
		if enemy.get_instance_id() == instance_id:
			return true

	return false

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
