extends Area2D


@onready var roster_member : Node2D = self.get_parent()


var character_name : String
var is_mouse_over_roster_member : bool
var current_selecting_role : String
var can_select_more : bool = true

var selected : bool
var selected_role : String


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PARTY_FILLED, _on_party_filled)
	PlanRadio.connect(PlanRadio.PARTY_UNFILLED, _on_party_unfilled)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


#=======================
# Signal Handlers
#=======================
func _on_party_filled() -> void:
	self.set("can_select_more", false)

func _on_party_unfilled() -> void:
	self.set("can_select_more", true)

func _on_mouse_entered() -> void:
	self.set("is_mouse_over_roster_member", true)
	self.roster_member.get_node("SelectOverlay").show()

func _on_mouse_exited() -> void:
	self.set("is_mouse_over_roster_member", false)
	self.roster_member.get_node("SelectOverlay").hide()

func _input(event) -> void:
	if not self.is_mouse_over_roster_member:
		return

	if self.is_left_mouse_click(event) and self.can_select_more and not self.selected:
		self.set("selected", true)
		self.set("selected_role", self.current_selecting_role)
		self.emit_roster_member_selected()
		return

	if self.is_left_mouse_click(event) and self.selected:
		self.emit_roster_member_deselected()
		self.set("selected", false)
		self.set("selected_role", "")
		return


#=======================
# Helpers
#=======================
func is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

func emit_roster_member_selected() -> void:
	PlanRadio.emit_signal(
		PlanRadio.ROSTER_MEMBER_SELECTED,
		self.character_name,
		self.selected_role
	)

func emit_roster_member_deselected() -> void:
	PlanRadio.emit_signal(
		PlanRadio.ROSTER_MEMBER_DESELECTED,
		self.character_name,
		self.selected_role
	)
