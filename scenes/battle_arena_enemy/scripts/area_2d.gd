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
# Input Handler Helpers
#========================
func _is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)
