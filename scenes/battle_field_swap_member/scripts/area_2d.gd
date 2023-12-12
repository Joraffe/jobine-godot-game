extends Area2D


@onready var battle_field_swap_member = get_parent()
var is_mouse_over_swap_member : bool = false
var can_swap : bool
var is_player_turn : bool
var sprite_original_global_position : Vector2


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)
	BattleRadio.connect(BattleRadio.CURRENT_SWAPS_UPDATED, _on_current_swaps_updated)


#========================
# Signal Handlers
#========================
func _on_mouse_entered() -> void:
	is_mouse_over_swap_member = true
	if battle_field_swap_member.is_player_turn:
		show_swap_icon()

func _on_mouse_exited() -> void:
	is_mouse_over_swap_member = false
	if battle_field_swap_member.is_player_turn:
		hide_swap_icon()

func _on_player_turn_started() -> void:
	is_player_turn = true

func _on_player_turn_ended() -> void:
	is_player_turn = false

func _on_current_swaps_updated(current_swaps : int) -> void:
	if current_swaps > 0:
		can_swap = true
		return

	if current_swaps == 0:
		can_swap = false
		return

func _input(event) -> void:
	if not battle_field_swap_member.is_player_turn:
		return

	if not is_mouse_over_swap_member:
		return

	if not (event is InputEventMouseButton):
		return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	if _is_left_mouse_click(event) and not can_swap:
		animate_cannot_swap()
		return

	if _is_left_mouse_click(event) and can_swap:
		BattleRadio.emit_signal(
			BattleRadio.CHARACTER_SWAPPED,
			battle_field_swap_member.swap_character,
			battle_field_swap_member.swap_position
		)


#========================
# Helpers
#========================
func _is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)


func show_swap_icon() -> void:
	battle_field_swap_member.get_node("SwapSprite2D").visible = true

func hide_swap_icon() -> void:
	battle_field_swap_member.get_node("SwapSprite2D").visible = false

func set_sprite_original_global_position() -> void:
	sprite_original_global_position = Vector2(
		$Sprite2D.global_position.x,
		$Sprite2D.global_position.y
	)

func animate_cannot_swap() -> void:
	var tween = create_tween()
	var slight_left = Vector2(
		sprite_original_global_position.x - 20,
		sprite_original_global_position.y
	)
	var slight_right = Vector2(
		sprite_original_global_position.x + 20,
		sprite_original_global_position.y
	)
	tween.tween_property(
		$Sprite2D,
		"global_position",
		slight_left,
		0.05,
	)
	tween.tween_property(
		$Sprite2D,
		"global_position",
		slight_right,
		0.05,
	)
	tween.tween_property(
		$Sprite2D,
		"global_position",
		sprite_original_global_position,
		0.05,
	)
