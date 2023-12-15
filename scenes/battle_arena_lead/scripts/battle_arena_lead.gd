extends Node2D


var lead_character : Character:
	set = set_lead_character

var image_data : ImageData = ImageData.new(
	"battle_arena_lead",
	"empty",
	"lead.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CHARACTER_SWAPPED, _on_character_swapped)
	BattleRadio.connect(BattleRadio.LEAD_DAMAGED, _on_lead_damaged)
	BattleRadio.connect(BattleRadio.LEAD_ELEMENT_APPLIED, _on_lead_element_applied)


#=======================
# Setters
#=======================
func set_lead_character(new_character : Character) -> void:
	lead_character = new_character

	$Combiner.set("entities", [self.lead_character])
	$Area2D.empty_lead()
	$Area2D.render_lead()
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_LEAD_UPDATED,
		self.lead_character
	)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("lead_character", battle_data.lead_character)

func _on_character_swapped(character : Character, _swap_position : String) -> void:
	self.set("lead_character", character)

func _on_lead_damaged(damage : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_DAMAGED,
		self.lead_character.get_instance_id(),
		damage
	)

func _on_lead_element_applied(element_name : String, num_applied : int) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ELEMENT_APPLIED_TO_ENTITY,
		self.lead_character.get_instance_id(),
		element_name,
		num_applied
	)

#=======================
# Node Helpers
#=======================
func get_child_node_by_entity_instance_id(entity_instance_id : int) -> Node2D:
	var child_node : Node2D

	var area_2d_children = $Area2D.get_children()
	for child in area_2d_children:
		var character = child.get("lead_character")
		if not character is Character:
			continue

		if entity_instance_id == character.get_instance_id():
			child_node = child
			break

	return child_node
