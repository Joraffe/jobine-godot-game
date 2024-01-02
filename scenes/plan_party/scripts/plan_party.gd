extends Node2D


var party_member_scene = preload("res://scenes/plan_party_member/PlanPartyMember.tscn")

var seed_data : Dictionary

var rendered_party_members : Dictionary

var party_lead : Character :
	set = set_party_lead
var party_standby_top : Character :
	set = set_party_standby_top
var party_standby_bottom : Character :
	set = set_party_standby_bottom

var image_data : ImageData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PLAN_STARTED, _on_plan_started)
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_SELECTED, _on_roster_member_selected)
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_DESELECTED, _on_roster_member_deselected)

func _ready() -> void:
	self.set("image_data", ImageData.new("plan_party", "container", "container.png"))


#=======================
# Setters
#=======================
func set_party_lead(new_party_lead : Character) -> void:
	party_lead = new_party_lead

func set_party_standby_top(new_party_standby_top : Character) -> void:
	party_standby_top = new_party_standby_top

func set_party_standby_bottom(new_party_standby_bottom : Character) -> void:
	party_standby_bottom = new_party_standby_bottom


#=======================
# Signal Handlers
#=======================
func _on_plan_started(plan_seed_data : Dictionary) -> void:
	self.set("rendered_party_members", {})
	self.set("seed_data", plan_seed_data)
	self.render_empty_party()

func _on_roster_member_selected(character_name : String, role_name : String) -> void:
	var character_seed_data : Dictionary = self.seed_data[SeedData.CHARACTERS]
	var character : Character = Character.create(character_seed_data[character_name])
	var instance : Node2D = self.instantiate_party_member(character, role_name)
	self.position_party_member(instance, role_name)
	var current_rendered_member : Node2D = self.rendered_party_members[role_name]
	current_rendered_member.queue_free()
	self.rendered_party_members[role_name] = instance

func _on_roster_member_deselected(_character_name : String, role_name : String) -> void:
	var current_rendered_member : Node2D = self.rendered_party_members[role_name]
	current_rendered_member.queue_free()
	self.render_unselected_party_member(role_name)


#=======================
# Helpers
#=======================
func render_empty_party() -> void:
	for role_name in PlanConstants.PARTY_ROLES:
		self.render_unselected_party_member(role_name)

func instantiate_unselected_party_member(role_name) -> Node2D:
	var instance : Node2D = party_member_scene.instantiate()
	instance.set("character_machine_name", PlanConstants.UNSELECTED)
	instance.set("character_element_name", PlanConstants.UNSELECTED)
	instance.set("character_max_hp", 0)
	instance.set("party_role", role_name)
	self.add_child(instance)
	return instance

func render_unselected_party_member(role_name) -> void:
	var instance : Node2D = self.instantiate_unselected_party_member(role_name)
	self.position_party_member(instance, role_name)
	self.rendered_party_members[role_name] = instance

func instantiate_party_member(character : Character, role_name : String) -> Node2D:
	var instance : Node2D = party_member_scene.instantiate()
	instance.set("character_machine_name", character.machine_name)
	instance.set("character_human_name", character.human_name)
	instance.set("character_max_hp", character.max_hp)
	instance.set("character_element_name", character.element_name)
	instance.set("character_combos", character.combo_synergies)
	instance.set("party_role", role_name)
	self.add_child(instance)
	return instance

func position_party_member(instance : Node2D, role_name : String) -> void:
	var starting_x : int = (-1) * int(self.image_data.get_img_width() / 2.0)
	var container_image_width : int = instance.container_image_data.get_img_width()
	var offset_x : int = int(container_image_width / 2.0)
	var index : int

	if role_name == PlanConstants.LEAD:
		index = 0
	elif role_name == PlanConstants.STANDBY_TOP:
		index = 1
	elif role_name == PlanConstants.STANDBY_BOTTOM:
		index = 2

	instance.position.x = starting_x + offset_x + container_image_width * index
