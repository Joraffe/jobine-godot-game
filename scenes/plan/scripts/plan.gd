extends Node2D


var seed_data : Dictionary


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.set("seed_data", SeedData.get_seed_data())


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlanRadio.emit_signal(PlanRadio.PLAN_STARTED, self.seed_data)
