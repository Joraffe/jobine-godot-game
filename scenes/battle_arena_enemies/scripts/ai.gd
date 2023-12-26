extends Node


@onready var battle_arena_enemies : Node2D = get_parent()

var lead_instance_id : int

var current_attacking_enemy : Enemy
var enemy_queue : Queue = Queue.new()
var attack_animation_queue : Queue = Queue.new()

# possibly delete this after potentially relocating _on_current_lead_updated
var is_enemy_turn : bool


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_ANIMATION_FINISHED, _on_enemy_attack_animation_finished)
	BattleRadio.connect(BattleRadio.EFFECTS_FINISHED, _on_effects_finished)


func _ready() -> void:
	$NextAttackDelayTimer.connect("timeout", _on_next_attack_delay_finished)
	$EndTurnDelayTimer.connect("timeout", _on_end_turn_delay_finished)


#========================
# Signal Handlers
#========================
func _on_next_attack_delay_finished() -> void:
	self.enqueue_next_enemy_attack_data()
	self.queue_next_enemy_attack_animation()

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
	self.emit_next_effect_queued()

func _on_effects_finished(effector_instance_id : int) -> void:
	if not self.is_enemy_turn:
		return

	if not self.current_attacking_enemy.get_instance_id() == effector_instance_id:
		return

	if not self.enemy_queue.is_empty():
		$NextAttackDelayTimer.start()
		return

	$EndTurnDelayTimer.start()


#=======================
# Helpers
#=======================
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

func enqueue_next_enemy_attack_data() -> void:
	var enemy : Enemy = self.enemy_queue.dequeue()
	self.set("current_attacking_enemy", enemy)
	var attack : EnemyAttack = self.get_random_enemy_attack(enemy)
	var attack_data : Dictionary = {
		"enemy": enemy,
		"attack": attack
	}
	self.attack_animation_queue.enqueue(attack_data)
	var attack_effects : Array[Dictionary] = attack.get_sequential_attack_effects()
	self.emit_effects_enqueued(enemy.get_instance_id(), attack_effects)

func queue_next_enemy_attack_animation() -> void:
	var attack_data : Dictionary = self.attack_animation_queue.dequeue()
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_ATTACK_ANIMATION_QUEUED,
		attack_data["enemy"].get_instance_id(),
		attack_data["attack"]
	)

func emit_effects_enqueued(enemy_instance_id : int, attack_effects : Array[Dictionary]) -> void:
	for attack_effect in attack_effects:
		attack_effect[BattleConstants.TARGET_INSTANCE_ID] = self.lead_instance_id
	# enemies always target the lead
	BattleRadio.emit_signal(
		BattleRadio.EFFECTS_ENQUEUED,
		enemy_instance_id,
		self.lead_instance_id,
		attack_effects
	)

func emit_next_effect_queued():
	BattleRadio.emit_signal(
		BattleRadio.NEXT_EFFECT_QUEUED,
		self.lead_instance_id
	)
