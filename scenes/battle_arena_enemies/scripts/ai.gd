extends Node


@onready var battle_arena_enemies : Node2D = get_parent()

var lead_instance_id : int

var is_enemy_turn : bool
var enemy_queue : Queue = Queue.new()

var current_enemy : Enemy

var attack_animation_queue : Queue = Queue.new()
var current_attacking_enemy : Enemy

var skip_animation_queue : Queue = Queue.new()

var end_effects_queue : Queue = Queue.new()
var reduce_effects_queued : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_ANIMATION_FINISHED, _on_enemy_attack_animation_finished)
	BattleRadio.connect(BattleRadio.END_TURN_ANIMATION_FINISHED, _on_end_turn_animation_finished)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)


func _ready() -> void:
	$NextAttackDelayTimer.connect("timeout", _on_next_attack_delay_finished)
	$EndTurnDelayTimer.connect("timeout", _on_end_turn_delay_finished)


#========================
# Signal Handlers
#========================
func _on_next_attack_delay_finished() -> void:
	var next_enemy : Enemy = self.dequeue_next_enemy()
	self.set("current_enemy", next_enemy)
	if self.has_end_turn_effects(next_enemy):
		self.end_effects_queue.enqueue(next_enemy)
		self.emit_end_effects_enqueued_for(next_enemy)

	if self.has_reduceable_status_effects(next_enemy):
		self.reduce_effects_queued.enqueue(next_enemy)
		self.emit_reduce_effects_enqueued_for(next_enemy)

	if next_enemy.can_attack():
		self.set("current_attacking_enemy", next_enemy)
		var attack : EnemyAttack = self.get_random_enemy_attack(next_enemy)
		var attack_effects : Array[Dictionary] = attack.get_sequential_attack_effects()
		self.emit_attack_effects_enqueued(next_enemy.get_instance_id(), attack_effects)
		self.emit_enemy_attack_animation_queued(next_enemy, attack)
	else:
		self.emit_end_turn_animation_queued(next_enemy)

func _on_end_turn_delay_finished() -> void:
	self.set("is_enemy_turn", false)
	BattleRadio.emit_signal(BattleRadio.TURN_ENDED, BattleConstants.GROUP_ENEMIES)

func _on_turn_started(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_ENEMIES:
		return

	self.set("is_enemy_turn", true)

	self.enqueue_enemies()
	$NextAttackDelayTimer.start()

func _on_enemy_attack_animation_finished(_enemy_instance_id : int) -> void:
	# once the animation is finished, queue the attack effects next
	self.emit_next_effect_queued(self.lead_instance_id)

func _on_end_turn_animation_finished(instance_id : int) -> void:
	if not self.is_enemy_turn:
		return

	self.emit_next_effect_queued(instance_id)

func _on_effects_finished(effector_instance_id : int) -> void:
	if not self.is_enemy_turn:
		return

	if self.is_current_enemy_effector(effector_instance_id):
		if self.has_any_remaining_effects():
			self.emit_next_effect_queued(self.current_enemy.get_instance_id())
			self.empty_effect_queues()
			return
		else:
			if not self.enemy_queue.is_empty():
				$NextAttackDelayTimer.start()
				return
			else:
				$EndTurnDelayTimer.start()
				return

	if self.is_reduce_or_end_turn_effector(effector_instance_id):
		self.empty_effect_queues()
		if not self.enemy_queue.is_empty():
			$NextAttackDelayTimer.start()
			return
		else:
			$EndTurnDelayTimer.start()
			return


#=======================
# Helpers
#=======================
func has_end_turn_effects(enemy : Enemy) -> bool:
	return enemy.has_any_status_effect_removal_effects()

func has_reduceable_status_effects(enemy : Enemy) -> bool:
	return enemy.has_reduceable_status_effects()

func has_any_remaining_effects() -> bool:
	return (
		self.end_effects_queue.size() > 0
		or self.reduce_effects_queued.size() > 0
	)

func empty_effect_queues() -> void:
	self.end_effects_queue.dequeue()
	self.reduce_effects_queued.dequeue()

func is_current_enemy_effector(effector_instance_id : int) -> bool:
	return self.current_enemy.get_instance_id() == effector_instance_id

func is_reduce_or_end_turn_effector(effector_instance_id : int) -> bool:
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

func emit_end_effects_enqueued_for(enemy : Enemy) -> void:
	var end_effects = enemy.get_sequential_status_effect_removal_effects(
		self.get_instance_id()
	)
	self.emit_end_effects_enqueued(
		enemy.get_instance_id(),
		end_effects
	)

func emit_end_effects_enqueued(instance_id : int, end_effects : Array[Dictionary]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		instance_id,
		end_effects
	)

func emit_reduce_effects_enqueued_for(enemy : Enemy) -> void:
	var status_effects_to_reduce : Array[StatusEffect] = enemy.get_reducable_status_effects()
	var reduce_effects : Array[Dictionary] = []
	for status_effect in status_effects_to_reduce:
		reduce_effects.append(
			status_effect.get_reduce_effect(
				self.get_instance_id(),
				enemy.get_instance_id()
			)
		)
	self.emit_reduce_effects_enqueued(enemy, reduce_effects)

func emit_reduce_effects_enqueued(enemy : Enemy, reduce_effects : Array[Dictionary]) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		self.get_instance_id(),
		enemy.get_instance_id(),
		reduce_effects
	)

func emit_enemy_attack_animation_queued(enemy : Enemy, attack : EnemyAttack) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_ATTACK_ANIMATION_QUEUED,
		enemy.get_instance_id(),
		attack
	)

func emit_end_turn_animation_queued(enemy : Enemy) -> void:
	BattleRadio.emit_signal(
		BattleRadio.END_TURN_ANIMATION_QUEUED,
		enemy.get_instance_id(),
		enemy.get_end_turn_animation_name()
	)

func emit_next_effect_queued(instance_id : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		instance_id
	)
