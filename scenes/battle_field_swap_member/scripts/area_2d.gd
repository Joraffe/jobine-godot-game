extends Area2D


@onready var battle_field_swap_member = get_parent()

var is_mouse_over_swap_member : bool = false

#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


#========================
# Signal Handlers
#========================
func _on_mouse_entered() -> void:
	is_mouse_over_swap_member = true
	show_swap_icon()

func _on_mouse_exited() -> void:
	is_mouse_over_swap_member = false
	hide_swap_icon()

func _input(event) -> void:
	if not is_mouse_over_swap_member:
		return

	if not (event is InputEventMouseButton):
		return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	BattleRadio.emit_signal(
		"character_swapped",
		battle_field_swap_member.data.character,
		battle_field_swap_member.data.swap_position
	)


#========================
# Helpers
#========================
func show_swap_icon() -> void:
	battle_field_swap_member.get_node("SwapSprite2D").visible = true

func hide_swap_icon() -> void:
	battle_field_swap_member.get_node("SwapSprite2D").visible = false
