extends Node


@onready var battle_arena_enemies : Node2D = get_parent()
var attacking_enemy_index : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENEMY_TURN_STARTED, _on_enemy_turn_started)

func _ready() -> void:
	$Timer.connect("timeout", _on_attack_timer_timeout)


#========================
# Signal Handlers
#========================
func _on_enemy_turn_started() -> void:
	$Timer.start()
	attacking_enemy_index = 0

func _on_attack_timer_timeout() -> void:
	var enemy : Enemy = battle_arena_enemies.enemies[self.attacking_enemy_index]
	var attack_name : String = enemy.get_random_attack_name()
	var attack : EnemyAttack = EnemyAttack.by_machine_name(
		attack_name,
		{EnemyAttack.ELEMENT_NAME : enemy.element_name}
	)
	BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_QUEUED, enemy, attack)

	if attacking_enemy_index < battle_arena_enemies.enemies.size() - 1:
		attacking_enemy_index += 1
	else:
		$Timer.stop()
