extends Area2D


@onready var battle_field_end_turn : Node2D = get_parent()
var is_mouse_over : bool = false


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


#========================
# Signal Handlers
#========================
func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false

func _input(event) -> void:
	if not battle_field_end_turn.is_player_turn:
		return

	if not is_mouse_over:
		return

	if not (event is InputEventMouseButton):
		return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	BattleRadio.emit_signal(
		BattleRadio.TURN_ENDED,
		BattleConstants.GROUP_PARTY
	)
