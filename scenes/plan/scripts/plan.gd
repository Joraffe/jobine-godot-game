extends Node2D


var seed_data : Dictionary

var plan_party : Dictionary
var plan_deck : Dictionary


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PARTY_UPDATED, _on_party_updated)
	PlanRadio.connect(PlanRadio.DECK_UPDATED, _on_deck_updated)
	PlanRadio.connect(PlanRadio.PLAN_CONFIRMED, _on_plan_confirmed)

func _ready() -> void:
	self.set("seed_data", SeedData.get_seed_data())
	PlanRadio.emit_signal(PlanRadio.PLAN_STARTED, self.seed_data)


#=======================
# Signal Handlers
#=======================
func _on_party_updated(party_data : Dictionary) -> void:
	self.set("plan_party", party_data)

func _on_deck_updated(deck_data : Dictionary) -> void:
	self.set("plan_deck", deck_data)

func _on_plan_confirmed() -> void:
	SceneSwitcher.goto_scene(
		"res://scenes/battle/Battle.tscn",
		{
			PlanConstants.PARTY : self.plan_party,
			PlanConstants.DECK : self.plan_deck
		}
	)
