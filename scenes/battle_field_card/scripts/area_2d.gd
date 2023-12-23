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
var card_played : bool = false
var lead_character : Character


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
	BattleRadio.connect(BattleRadio.ENEMY_TARGET_SELECTED, _on_enemy_target_selected)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_CHECK_DEFERRED, _on_combo_bonus_check_deferred)


#========================
# Signal Handlers
#========================
func _on_mouse_entered():
	is_mouse_over_card = true

func _on_mouse_exited():
	is_mouse_over_card = false

func _on_card_selected(card : Card) -> void:	
	if not is_another_card_selected and card != battle_field_card.card:
		confirm_another_card_selected()

func _on_card_deselected(card : Card) -> void:
	if is_another_card_selected and card != battle_field_card.card:
		confirm_another_card_not_selected()

func _on_card_targeting_enabled() -> void:
	if not selected:
		return

	enable_card_targeting()
	add_targeting_line_starting_point()
	show_card_targeting()
	hide_mouse_cursor()

func _on_card_targeting_disabled() -> void:
	if not selected:
		return

	clean_up_card_targeting()

func _on_enemy_target_selected(enemy : Enemy) -> void:
	if not selected:
		confirm_another_card_not_selected()
		return

	# Stuff related to updating this card visually
	deselect_card()
	clean_up_card_targeting()
	move_card_to_discard_pile()
	set_card_played()

	# Stuff related to actually playing the card effects
	BattleRadio.emit_signal(
		BattleRadio.CARD_PLAYED,
		self.battle_field_card.card
	)
	BattleRadio.emit_signal(
		BattleRadio.CARD_EFFECTS_DEFERRED_TO_GROUP,
		BattleConstants.GROUP_ENEMIES,
		self.battle_field_card.card,
		enemy.get_instance_id()
	)

func _on_combo_bonus_check_deferred(combiner : Combiner, target_intance_id : int) -> void:
	if not self.card_played:
		return
	
	var card : Card = self.battle_field_card.card
	if not card.combo_trigger:
		self.emit_card_freed(card)
		return

	var combo_name : String = combiner.current_combo.machine_name
	var combo_trigger_name : String = card.combo_trigger.machine_name
	if combo_name != combo_trigger_name:
		self.emit_card_freed(card)
		return

	var combo_bonus : ComboBonus = card.combo_bonus
	# for non-combat effects (i.e. energy, swaps, cards)
	if combo_bonus.is_self_non_targeting():
		self.emit_self_non_targeting_combo_bonus_applied(combo_bonus)
		self.emit_card_freed(card)
		return

	# for combat effects (i.e. extra damage)
	if combo_bonus.is_other_targeting():
		self.emit_combo_bonus_effects_deferred_to_group(
			BattleConstants.GROUP_ENEMIES,
			combo_bonus,
			target_intance_id
		)
		self.emit_card_freed(card)
		return

	if combo_bonus.is_self_targeting():
		self.emit_combo_bonus_effects_deferred_to_group(
			BattleConstants.GROUP_PARTY,
			combo_bonus,
			card.character_instance_id
		)
		self.emit_card_freed(card)
		return

func _input(event):
	if not battle_field_card.is_player_turn:
		return
	
	if is_another_card_selected:
		return

	if not is_mouse_over_card and not selected:
		return

	if (not selected and _is_left_mouse_click(event)
		and not battle_field_card.can_play_card()):
		animate_cannot_play()
		return

	if (not selected and _is_left_mouse_click(event)
		and battle_field_card.can_play_card()):
		select_card()
		BattleRadio.emit_signal(
			BattleRadio.CARD_SELECTED,
			battle_field_card.card
		)
		move_sprite_z_index(1)
		move_card_to_mouse(event)
		return

	if selected and _is_right_mouse_click(event):
		deselect_card()
		BattleRadio.emit_signal(
			BattleRadio.CARD_DESELECTED,
			battle_field_card.card
		)
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


#========================
# Helpers
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

func deselect_card() -> void:
	selected = false

func select_card() -> void:
	selected = true

func enable_card_targeting() -> void:
	is_targeting_enabled = true

func disable_card_targeting() -> void:
	is_targeting_enabled = false

func confirm_another_card_selected() -> void:
	is_another_card_selected = true

func confirm_another_card_not_selected() -> void:
	is_another_card_selected = false

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

func animate_cannot_play() -> void:
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

func move_card_to_discard_pile() -> void:
	var tween = create_tween()
	tween.tween_property(
		$Sprite2D,
		"global_position",
		Vector2(1600, 870),  # Roughly where the discard pile is
		0.2
	)
	tween.parallel().tween_property(
		$Sprite2D,
		"scale",
		Vector2(),
		0.2
	)
	tween.tween_callback(hide_card_after_played)

func hide_card_after_played() -> void:
	battle_field_card.visible = false

func set_card_played() -> void:
	card_played = true

func targeting_arrow_look_at_mouse(event) -> void:
	var far_left = Vector2(350, 350)
	var far_right = Vector2(1850, 350)
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

func clean_up_card_targeting() -> void:
	disable_card_targeting()
	empty_targeting_line_points()
	hide_card_targeting()
	show_mouse_cursor()

func position_targeting() -> void:
	# When creating cards for the first time, they're spawned
	# at the center of the hand; handy to store this for
	# later use when wanting to center cards during targeting
	card_targeting_position = self.global_position + Vector2(0, -50)
	battle_field_card_targeting.global_position = card_targeting_position

func emit_self_non_targeting_combo_bonus_applied(combo_bonus : ComboBonus) -> void:
	BattleRadio.emit_signal(
		BattleRadio.SELF_NON_TARGETING_COMBO_BONUS_APPLIED,
		combo_bonus
	)

func emit_combo_bonus_effects_deferred_to_group(
	group_name : String,
	combo_bonus : ComboBonus, 
	target_instance_id : int
) -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_BONUS_EFFECTS_DEFERRED_TO_GROUP,
		group_name,
		combo_bonus,
		target_instance_id
	)

func emit_card_freed(card : Card) -> void:
	BattleRadio.emit_signal(
		BattleRadio.CARD_FREED,
		card
	)
