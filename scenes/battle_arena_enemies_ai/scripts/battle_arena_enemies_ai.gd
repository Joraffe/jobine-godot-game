extends Node


@onready var battle_arena_enemies : Node2D = get_parent()
var num_enemies_attacked : int

var attack_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENEMY_TURN_STARTED, _on_enemy_turn_started)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_FINISHED, _on_enemy_attack_finished)

func _ready() -> void:
	$AttackDelayTimer.connect("timeout", _on_attack_delay_finished)
	$EndTurnTimer.connect("timeout", _on_end_turn_delay_finished)


#========================
# Signal Handlers
#========================
func _on_enemy_turn_started() -> void:
	for enemy in self.battle_arena_enemies.enemies:
		self.attack_queue.enqueue(enemy)

	$AttackDelayTimer.start()

func _on_enemy_attack_finished() -> void:
	num_enemies_attacked += 1
	if self.num_enemies_attacked == self.battle_arena_enemies.enemies.size():
		$EndTurnTimer.start()
	else:
		$AttackDelayTimer.start()

func _on_attack_delay_finished() -> void:
	var enemy : Enemy = self.attack_queue.dequeue()
	var attack_name : String = enemy.get_random_attack_name()
	var attack : EnemyAttack = EnemyAttack.by_machine_name(
		attack_name,
		{EnemyAttack.ELEMENT_NAME : enemy.element_name}
	)
	BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_QUEUED, enemy, attack)


func _on_end_turn_delay_finished() -> void:
	BattleRadio.emit_signal(BattleRadio.ENEMY_TURN_ENDED)
