extends Node2D


var roster_member_scene = preload("res://scenes/plan_roster_member/PlanRosterMember.tscn")


var roster : Dictionary :
	set = set_roster
var current_selecting_role : String :
	set = set_current_selecting_role

var available_roles : Dictionary
var party_filled : bool

var image_data : ImageData :
	set = set_image_data
var roster_container_width : int


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PLAN_STARTED, _on_plan_started)
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_SELECTED, _on_roster_member_selected)
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_DESELECTED, _on_roster_member_deselected)


func _ready() -> void:
	self.set("image_data", ImageData.new("plan_roster", "container", "container.png"))


#=======================
# Setters
#=======================
func set_roster(new_roster : Dictionary) -> void:
	roster = new_roster

	self.render_roster()

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	self.set("roster_container_width", self.image_data.get_img_width())

func set_current_selecting_role(new_current_selecting_role : String) -> void:
	current_selecting_role = new_current_selecting_role

	for child in self.get_children():
		if child is Node2D:  # aka PlanRosterMember
			child.set("current_selecting_role", self.current_selecting_role)


#=======================
# Signal Handlers
#=======================
func _on_plan_started(seed_data : Dictionary) -> void:
	self.set("available_roles", {
		PlanConstants.LEAD : true,
		PlanConstants.STANDBY_TOP : true,
		PlanConstants.STANDBY_BOTTOM : true
	})
	self.set("current_selecting_role", self.get_next_role())
	self.set("roster", seed_data[SeedData.CHARACTERS])

func _on_roster_member_selected(_character_name : String, selected_role : String) -> void:
	self.available_roles[selected_role] = false
	var next_role = self.get_next_role()
	if next_role:
		self.set("current_selecting_role", self.get_next_role())
	else:
		self.set("party_filled", true)
		self.emit_party_filled()

func _on_roster_member_deselected(_character_name : String, deselected_role) -> void:
	self.available_roles[deselected_role] = true
	self.set("current_selecting_role", self.get_next_role())
	if self.party_filled:
		self.set("party_filled", false)
		self.emit_party_unfilled()


#=======================
# Helpers
#=======================
func render_roster() -> void:
#	var character_names : Array = self.roster.keys()
	var character_names : Array = self.current_implemented_characters()
	for i in character_names.size():
		var character_name = character_names[i]
		var roster_member : Node2D = self.instantiate_roster_member(character_name)
		self.position_roster_member(roster_member, i)

func instantiate_roster_member(character_name : String) -> Node2D:
	var instance = roster_member_scene.instantiate()
	instance.set("character_name", character_name)
	instance.set("current_selecting_role", self.current_selecting_role)
	self.add_child(instance)
	return instance

func position_roster_member(instance : Node2D, index_position : int) -> void:
	var starting_x : int = (-1) * int(self.roster_container_width / 2.0)
	var roster_member_width : int = instance.image_data.get_img_width()
	var offset_x : int = int(roster_member_width / 2.0)
	instance.position.x = starting_x + offset_x + roster_member_width * index_position

func current_implemented_characters() -> Array:
	return [
		Character.JUNO,
		Character.AXO,
		Character.PETTOL,
		Character.MAU,
		Character.EB
	]

func get_next_role() -> String:
	var next_role : String

	if self.available_roles[PlanConstants.LEAD]:
		next_role = PlanConstants.LEAD
	elif self.available_roles[PlanConstants.STANDBY_TOP]:
		next_role = PlanConstants.STANDBY_TOP
	elif self.available_roles[PlanConstants.STANDBY_BOTTOM]:
		next_role = PlanConstants.STANDBY_BOTTOM

	return next_role

func emit_party_filled() -> void:
	PlanRadio.emit_signal(PlanRadio.PARTY_FILLED)

func emit_party_unfilled() -> void:
	PlanRadio.emit_signal(PlanRadio.PARTY_UNFILLED)
