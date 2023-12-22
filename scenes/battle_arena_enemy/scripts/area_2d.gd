extends Area2D


@onready var battle_arena_enemy : Node2D = get_parent()
var is_player_turn : bool
var targetable : bool = false
var is_mouse_over : bool = false


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.CARD_TARGETING_ENABLED, _on_card_targeting_enabled)
	BattleRadio.connect(BattleRadio.CARD_TARGETING_DISABLED, _on_card_targeting_disabled)


#========================
# Signal Handlers
#========================
func _on_card_targeting_enabled() -> void:
	targetable = true

func _on_card_targeting_disabled() -> void:
	targetable = false

func _on_player_turn_started() -> void:
	is_player_turn = true

func _on_player_turn_ended() -> void:
	is_player_turn = false

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false

func _input(event) -> void:
	if not is_mouse_over:
		return

	if not targetable:
		return

	if not is_player_turn:
		return

	if _is_left_mouse_click(event):
		BattleRadio.emit_signal(
			BattleRadio.ENEMY_TARGET_SELECTED,
			battle_arena_enemy.enemy
		)
		return


#========================
# Helpers
#========================
func _is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

func animate(_attack : EnemyAttack) -> void:
	var tween = create_tween()
	var sprite_2d : Sprite2D = $Sprite2D
	var original_pos : Vector2 = sprite_2d.position
	var left_nudge_pos = Vector2(
		sprite_2d.position.x - 50,
		sprite_2d.position.y
	)
	tween.tween_property(
		$Sprite2D,
		"position",
		left_nudge_pos,
		0.1,
	)
	tween.tween_property(
		$Sprite2D,
		"position",
		original_pos,
		0.1,
	)

	tween.tween_callback(self.emit_enemy_attack_animation_finished)

func animate_enemy_defeated() -> void:
	print('animate_enemy_defeated called')
	var tween = self.create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, 1)
	tween.tween_callback(self.emit_animation_finished_and_free_entity)

func emit_animation_finished_and_free_entity() -> void:
	print('emit_animation_finished_and_free_entity called')
	var enemy_instance_id : int = battle_arena_enemy.enemy.get_instance_id()
	battle_arena_enemy.queue_free()
	self.emit_enemy_defeated_animation_finished(enemy_instance_id)

func emit_enemy_defeated_animation_finished(instance_id : int) -> void:
	print('emit_enemy_defeated_animation_finished called')
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_DEFEATED_ANIMATION_FINISHED,
		instance_id
	)

func emit_enemy_attack_animation_finished() -> void:
	BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_ANIMATION_FINISHED)
