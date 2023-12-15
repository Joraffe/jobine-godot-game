extends Node


@onready var battle_arena_enemies : Node2D = get_parent()

var is_enemy_turn : bool
var elements_settled : bool
var animation_finished : bool

var attack_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENEMY_TURN_STARTED, _on_enemy_turn_started)
	BattleRadio.connect(BattleRadio.ELEMENTS_SETTLED, _on_elements_settled)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_FINISHED, _on_enemy_attack_finished)

func _ready() -> void:
	$AttackDelayTimer.connect("timeout", _on_attack_delay_finished)
	$EndTurnTimer.connect("timeout", _on_end_turn_delay_finished)


#========================
# Signal Handlers
#========================
func _on_enemy_turn_started() -> void:
	self.set("is_enemy_turn", true)
	self.reset_attack_checks()
	for enemy in self.battle_arena_enemies.enemies:
		self.attack_queue.enqueue(enemy)

	$AttackDelayTimer.start()

func _on_elements_settled() -> void:
	if not self.is_enemy_turn:
		return

	self.set("elements_settled", true)
	self.check_for_attack_finished()

func _on_enemy_attack_finished() -> void:
	self.set("animation_finished", true)
	self.check_for_attack_finished()

func _on_attack_delay_finished() -> void:
	var enemy : Enemy = self.attack_queue.dequeue()
	var attack_name : String = enemy.get_random_attack_name()
	var attack : EnemyAttack = EnemyAttack.by_machine_name(
		attack_name,
		{EnemyAttack.ELEMENT_NAME : enemy.element_name}
	)
	BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_QUEUED, enemy, attack)


func _on_end_turn_delay_finished() -> void:
	self.set("is_enemy_turn", false)
	BattleRadio.emit_signal(BattleRadio.ENEMY_TURN_ENDED)


#=======================
# Helpers
#=======================
func check_for_attack_finished() -> void:
	if not self.animation_finished or not self.elements_settled:
		return
	if self.has_remaining_enemy_attacks():
		self.reset_attack_checks()
		$AttackDelayTimer.start()
	else:
		$EndTurnTimer.start()

func has_remaining_enemy_attacks() -> bool:
	return not self.attack_queue.is_empty()

func reset_attack_checks() -> void:
	self.set("elements_settled", false)
	self.set("animation_finished", false)
