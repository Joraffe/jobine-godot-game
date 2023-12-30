extends Area2D


var character_scene = preload("res://scenes/battle_arena_character/BattleArenaCharacter.tscn")


var standby_character : Character :
	set = set_standby_character

var standby_position : String
var is_mouse_over_standby_member : bool
var is_player_turn : bool
var num_current_swaps : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect(BattleRadio.TURN_STARTED, _on_turn_started)
	BattleRadio.connect(BattleRadio.TURN_ENDED, _on_turn_ended)
	BattleRadio.connect(BattleRadio.CURRENT_SWAPS_UPDATED, _on_current_swaps_updated)


#=======================
# Setters
#=======================
func set_standby_character(new_standby_character : Character) -> void:
	standby_character = new_standby_character
	self.empty_standby_character()
	self.render_standby_character()


#=======================
# Signal Handlers
#=======================
func _on_mouse_entered() -> void:
	self.set("is_mouse_over_standby_member", true)

func _on_mouse_exited() -> void:
	self.set("is_mouse_over_standby_member", false)

func _on_turn_started(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", true)

func _on_turn_ended(group_name : String) -> void:
	if group_name != BattleConstants.GROUP_PARTY:
		return

	self.set("is_player_turn", false)

func _on_current_swaps_updated(new_current_swaps : int) -> void:
	self.set("num_current_swaps", new_current_swaps)

func _input(event) -> void:
	if not self.is_player_turn:
		return

	if not self.is_mouse_over_standby_member:
		return

	if not MouseUtils.is_left_click(event):
		return

	if MouseUtils.is_left_click(event) and not self.can_swap():
		self.animate_cannot_swap()
		return

	if MouseUtils.is_left_click(event) and self.can_swap():
		BattleRadio.emit_signal(
			BattleRadio.STANDBY_SWAP_TO_LEAD_QUEUED,
			self.standby_character.get_instance_id()
		)


#=======================
# Helpers
#=======================
func empty_standby_character() -> void:
	for child in self.get_children():
		if child.get("character") is Character:
			child.queue_free()

func render_standby_character() -> void:
	self.instantiate_standby_character(self.standby_character)

func instantiate_standby_character(character : Character) -> void:
	var instance = character_scene.instantiate()
	instance.set("character_type", "party_standby")
	instance.set("character", character)
	add_child(instance)
	instance.get_node("HealthBar").update_health_bar()

func animate_cannot_swap() -> void:
	var tween = self.create_tween()
	var character_node : Node2D = self.get_character_node()
	var character_area2d : Area2D = character_node.get_node("Area2D")
	var original_position : Vector2 = character_node.position
	var slight_left = Vector2(original_position.x - 20,original_position.y)
	var slight_right = Vector2(original_position.x + 20, original_position.y)
	tween.tween_property(character_area2d, "position", slight_left, 0.05)
	tween.tween_property(character_area2d, "position", slight_right, 0.05)
	tween.tween_property(character_area2d, "position", original_position, 0.05)

func get_character_node() -> Node2D:
	var character_node : Node2D

	for child in self.get_children():
		if child.get("character") is Character:
			character_node = child
			break

	return character_node

func has_enough_swaps() -> bool:
	return self.num_current_swaps > 0

func has_not_fainted() -> bool:
	return not self.standby_character.has_fainted()

func standby_character_can_act() -> bool:
	return self.standby_character.can_act()

func can_swap() -> bool:
	return (
		self.has_enough_swaps()
		and self.has_not_fainted()
		and self.standby_character_can_act()
	)
