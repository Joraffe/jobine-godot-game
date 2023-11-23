extends Area2D


var is_mouse_over_card : bool = false
var card_selected : bool = false
var sprite_original_global_position : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Do something with these later, perhaps animating
func _on_mouse_entered():
	is_mouse_over_card = true


func _on_mouse_exited():
	is_mouse_over_card = false


func _is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)


func _is_right_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_RIGHT
		and event.pressed
	)


func _is_mouse_move(event) -> bool:
	return event is InputEventMouseMotion


func _input(event):
	if not is_mouse_over_card and not card_selected:
		return

	if not card_selected and _is_left_mouse_click(event):
		select_card()
		move_sprite_z_index(1)
		move_card_to_mouse(event)
		return

	if card_selected and _is_right_mouse_click(event):
		deselect_card()
		move_sprite_z_index(0)
		move_card_to_original_position()
		return

	if card_selected and _is_mouse_move(event):
		move_card_to_mouse(event)
		return


func deselect_card():
	card_selected = false


func select_card():
	card_selected = true
	

func move_sprite_z_index(new_z_index) -> void:
	$Sprite2D.z_index = new_z_index


func move_card_to_mouse(event) -> void:
	var mouse_position = event.position

	var tween = create_tween()
	tween.tween_property(
		$Sprite2D,
		"global_position",
		mouse_position,
		0.05
	)


func move_card_to_original_position() -> void:
	var tween = create_tween()
	tween.tween_property(
		$Sprite2D,
		"global_position",
		sprite_original_global_position,
		0.1
	)


func set_sprite_original_global_position():
	sprite_original_global_position = Vector2(
		$Sprite2D.global_position.x,
		$Sprite2D.global_position.y
	)
