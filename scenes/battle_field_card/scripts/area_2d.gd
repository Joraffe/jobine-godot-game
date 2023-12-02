extends Area2D


@onready var battle_field_card : Node2D = get_parent()
@onready var battle_field_card_targeting : Node2D = $BattleFieldCardTargeting
@onready var targeting_area_2d : Area2D = $BattleFieldCardTargeting/Area2D
@onready var targeting_area_sprite_2d : Sprite2D = $BattleFieldCardTargeting/Area2D/Sprite2D
@onready var targeting_line_2d : Line2D = $BattleFieldCardTargeting/Line2D

var is_another_card_selected : bool = false
var is_mouse_over_card : bool = false
var selected : bool = false
var is_targeting_enabled : bool = false
var sprite_original_global_position : Vector2
var card_targeting_position : Vector2


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	position_targeting()

	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect(BattleRadio.CARD_SELECTED, _on_card_selected)
	BattleRadio.connect(BattleRadio.CARD_DESELECTED, _on_card_deselected)
	BattleRadio.connect(BattleRadio.CARD_TARGETING_ENABLED, _on_card_targeting_enabled)
	BattleRadio.connect(BattleRadio.CARD_TARGETING_DISABLED, _on_card_targeting_disabled)


#========================
# Signal Handlers
#========================
# Do something with these later, perhaps animating
func _on_mouse_entered():
	is_mouse_over_card = true

func _on_mouse_exited():
	is_mouse_over_card = false

func _on_card_selected(card : Card) -> void:	
	if not is_another_card_selected and card != battle_field_card.data.card:
		is_another_card_selected = true

func _on_card_deselected(card : Card) -> void:
	if is_another_card_selected and card != battle_field_card.data.card:
		is_another_card_selected = false

func _on_card_targeting_enabled() -> void:
	if not selected:
		return

	is_targeting_enabled = true
	add_targeting_line_starting_point()
	show_card_targeting()
	hide_mouse_cursor()

func _on_card_targeting_disabled() -> void:
	if not selected:
		return

	is_targeting_enabled = false
	empty_targeting_line_points()
	hide_card_targeting()
	show_mouse_cursor()

#========================
# Input Handler Helpers
#========================
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
	if is_another_card_selected:
		return

	if not is_mouse_over_card and not selected:
		return

	if not selected and _is_left_mouse_click(event):
		select_card()
		BattleRadio.emit_signal("card_selected", battle_field_card.data.card)
		move_sprite_z_index(1)
		move_card_to_mouse(event)
		return

	if selected and _is_right_mouse_click(event):
		deselect_card()
		BattleRadio.emit_signal("card_deselected", battle_field_card.data.card)
		move_sprite_z_index(0)
		hide_card_targeting()
		empty_targeting_line_points()
		show_mouse_cursor()
		move_card_to_original_position()
		return

	# if we've selected the card and are moving it while outside of
	# the BattleArena (i.e. when we first select the card)
	if selected and not is_targeting_enabled and _is_mouse_move(event):
		move_card_to_mouse(event)
		return

	# if we've selected the card and have moved it to the BattleArena
	# to enable the targeting and it's a card with controlled targeting
	if selected and is_targeting_enabled and _is_mouse_move(event):
		move_card_to_targeting_position()
		targeting_arrow_look_at_mouse(event)
		move_targeting_arrow_to_mouse(event)
		draw_targeting_line_to_arrow()
		return


func deselect_card() -> void:
	selected = false

func select_card() -> void:
	selected = true

func show_card_targeting() -> void:
	battle_field_card_targeting.visible = true

func hide_card_targeting() -> void:
	battle_field_card_targeting.visible = false

func hide_mouse_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func show_mouse_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	
func move_card_to_targeting_position() -> void:
	var tween = create_tween()
	tween.tween_property(
		$Sprite2D,
		"global_position",
		card_targeting_position,
		0.1
	)

func targeting_arrow_look_at_mouse(event) -> void:
	var far_left = Vector2(350, 350)
	var far_right = Vector2(1450, 350)
	var viewport = get_viewport()
	var viewport_width = viewport.size.x
	var look_at_position : Vector2

	if event.position.x > viewport_width / 2:
		look_at_position = far_right
	if event.position.x < viewport_width / 2:
		look_at_position = far_left

	targeting_area_sprite_2d.look_at(look_at_position)
	targeting_area_sprite_2d.rotate(PI/2)


func move_targeting_arrow_to_mouse(event) -> void:
	var mouse_position = event.position

	var tween = create_tween()
	tween.tween_property(
		targeting_area_2d,
		"global_position",
		mouse_position,
		0.05
	)


func set_sprite_original_global_position():
	sprite_original_global_position = Vector2(
		$Sprite2D.global_position.x,
		$Sprite2D.global_position.y
	)

func add_targeting_line_starting_point() -> void:
	targeting_line_2d.add_point(targeting_line_2d.position)

func empty_targeting_line_points() -> void:
	targeting_line_2d.clear_points()

func draw_targeting_line_to_arrow() -> void:
	var num_points = targeting_line_2d.get_point_count()

	if num_points > 1:
		targeting_line_2d.remove_point(1)

	targeting_line_2d.add_point(
		targeting_line_2d.get_local_mouse_position()
	)


func position_targeting() -> void:
	# When creating cards for the first time, they're spawned
	# at the center of the hand; handy to store this for
	# later use when wanting to center cards during targeting
	card_targeting_position = self.global_position + Vector2(0, -50)
	battle_field_card_targeting.global_position = card_targeting_position
