extends Node


@onready var battle_arena_enemies : Node2D = get_parent()

var lead_instance_id : int

var is_enemy_turn : bool
var enemy_queue : Queue = Queue.new()

var attack_animation_queue : Queue = Queue.new()
var current_attacking_enemy : Enemy

var skip_animation_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_ANIMATION_FINISHED, _on_enemy_attack_animation_finished)
	BattleRadio.connect(BattleRadio.SKIP_TURN_ANIMATION_FINISHED, _on_skip_turn_animation_finished)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)


func _ready() -> void:
	$NextAttackDelayTimer.connect("timeout", _on_next_attack_delay_finished)
	$EndTurnDelayTimer.connect("timeout", _on_end_turn_delay_finished)


#========================
# Signal Handlers
#========================
func _on_next_attack_delay_finished() -> void:
	var next_enemy : Enemy = self.dequeue_next_enemy()
	if next_enemy.can_attack():
		self.enqueue_next_enemy_attack_data(next_enemy)
		self.enqueue_next_enemy_status_effect_reduction_data(next_enemy)
		self.queue_next_enemy_attack_animation()
	else:
		self.enqueue_next_enemy_skip_turn_data(next_enemy)
		self.enqueue_next_enemy_status_effect_reduction_data(next_enemy)
		self.queue_next_enemy_skip_turn_animation()

func _on_end_turn_delay_finished() -> void:
	self.set("is_enemy_turn", false)
	BattleRadio.emit_signal(BattleRadio.TURN_ENDED, BattleConstants.GROUP_ENEMIES)

func _on_turn_started(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	self.set("is_enemy_turn", true)

	self.enqueue_enemies()
	$NextAttackDelayTimer.start()

func _on_enemy_attack_animation_finished() -> void:
	# once the animation is finished, queue the attack effects next
	self.emit_next_attack_effect_queued()

func _on_skip_turn_animation_finished(instance_id : int) -> void:
	# once the skip turn animation is finished,
	# queue the next effects associated with the skip
	self.emit_next_skip_effect_queued(instance_id)

func _on_effects_finished(effector_instance_id : int) -> void:
	if not self.is_enemy_turn:
		return

	if not self.is_effector_relevant(effector_instance_id):
		return

	if not self.enemy_queue.is_empty():
		$NextAttackDelayTimer.start()
		return

	$EndTurnDelayTimer.start()


#=======================
# Helpers
#=======================
func is_effector_relevant(effector_instance_id : int) -> bool:
	return (
		self.is_skipping_effect(effector_instance_id)
		or self.is_current_attacking_enemy_effector(effector_instance_id) 
	)

func is_current_attacking_enemy_effector(effector_instance_id : int) -> bool:
	return self.current_attacking_enemy.get_instance_id() == effector_instance_id

func is_skipping_effect(effector_instance_id : int) -> bool:
	return self.get_instance_id() == effector_instance_id

func get_random_enemy_attack(enemy : Enemy) -> EnemyAttack:
	var attack_name : String = enemy.get_random_attack_name()
	var attack_data : Dictionary = {
		EnemyAttack.ELEMENT_NAME : enemy.element_name,
		EnemyAttack.ENEMY_INSTANCE_ID : enemy.get_instance_id()
	}
	var attack : EnemyAttack = EnemyAttack.by_machine_name(attack_name, attack_data)
	return attack

func enqueue_enemies() -> void:
	for enemy in self.battle_arena_enemies.enemies:
		self.enemy_queue.enqueue(enemy)

func dequeue_next_enemy() -> Enemy:
	return self.enemy_queue.dequeue()


# Related to enemy attacks
func enqueue_next_enemy_attack_data(attacking_enemy : Enemy) -> void:
	self.set("current_attacking_enemy", attacking_enemy)
	var attack : EnemyAttack = self.get_random_enemy_attack(attacking_enemy)
	var attack_data : Dictionary = {
		"enemy": attacking_enemy,
		"attack": attack
	}
	self.attack_animation_queue.enqueue(attack_data)
	var attack_effects : Array[Dictionary] = attack.get_sequential_attack_effects()
	self.emit_attack_effects_enqueued(attacking_enemy.get_instance_id(), attack_effects)

func queue_next_enemy_attack_animation() -> void:
	var attack_data : Dictionary = self.attack_animation_queue.dequeue()
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_ATTACK_ANIMATION_QUEUED,
		attack_data["enemy"].get_instance_id(),
		attack_data["attack"]
	)

func emit_attack_effects_enqueued(enemy_instance_id : int, attack_effects : Array[Dictionary]) -> void:
	for attack_effect in attack_effects:
		attack_effect[BattleConstants.TARGET_INSTANCE_ID] = self.lead_instance_id
	# enemies always target the lead
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		enemy_instance_id,
		self.lead_instance_id,
		attack_effects
	)

func emit_next_attack_effect_queued():
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		self.lead_instance_id
	)

# Related to skipping enemy turns
func enqueue_next_enemy_skip_turn_data(skipping_enemy : Enemy) -> void:
	var reason : String = self.cannot_attack_reason(skipping_enemy)
	var skip_data : Dictionary = {
		"enemy" : skipping_enemy,
		"reason" : reason
	}
	self.skip_animation_queue.enqueue(skip_data)
	var skip_effects : Array[Dictionary] = self.get_sequential_skip_effects(skipping_enemy, reason)
	self.emit_skip_effects_enqueued(skipping_enemy.get_instance_id(), skip_effects)

func queue_next_enemy_skip_turn_animation() -> void:
	var skip_data : Dictionary = self.skip_animation_queue.dequeue()
	BattleRadio.emit_signal(
		BattleRadio.SKIP_TURN_ANIMATION_QUEUED,
		skip_data["enemy"].get_instance_id(),
		skip_data["reason"]
	)

func emit_skip_effects_enqueued(skipping_enemy_instance_id : int, skip_effects) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		skipping_enemy_instance_id,
		skip_effects
	)

func emit_next_skip_effect_queued(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		instance_id
	)

func cannot_attack_reason(skipping_enemy : Enemy) -> String:
	var reason : String = ""

	if skipping_enemy.is_frozen():
		reason = BattleConstants.SKIP_FROZEN

	return reason

func get_sequential_skip_effects(skipping_enemy : Enemy, reason : String) -> Array[Dictionary]:
	var skip_effects : Array[Dictionary] = []

	if reason == BattleConstants.SKIP_FROZEN:
		skip_effects.append(self.get_frozen_immunity_effect(skipping_enemy))

	return skip_effects

func get_frozen_immunity_effect(skipping_enemy : Enemy) -> Dictionary:
	return {
		BattleConstants.EFFECTOR_INSTANCE_ID : self.get_instance_id(),
		BattleConstants.TARGET_INSTANCE_ID : skipping_enemy.get_instance_id(),
		BattleConstants.EFFECT_TYPE : BattleConstants.STATUS_EFFECT,
		BattleConstants.EFFECT_NAME : StatusEffect.FROZEN_IMMUNE,
		BattleConstants.EFFECT_AMOUNT : 1
	}


# Related to reducing status effects
func enqueue_next_enemy_status_effect_reduction_data(next_enemy : Enemy) -> void:
	var status_effects_to_reduce : Array[StatusEffect] = next_enemy.get_reducable_status_effects()
	var reduce_effects : Array[Dictionary] = []
	for status_effect in status_effects_to_reduce:
		reduce_effects.append(
			status_effect.get_reduce_effect(
				self.get_instance_id(),
				next_enemy.get_instance_id()
			)
		)
	self.emit_reduce_effects_enqueued(next_enemy, reduce_effects)

func emit_reduce_effects_enqueued(enemy : Enemy, reduce_effects : Array[Dictionary]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		enemy.get_instance_id(),
		reduce_effects
	)
