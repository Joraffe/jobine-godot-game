extends Node2D


var aura_element_scene : PackedScene = preload(
	"res://scenes/battle_arena_aura_element/BattleArenaAuraElement.tscn"
)

var entity : Variant :  # used to associate this with an character/enemy
	set = set_entity
var aura_width : int  # used to position individual aura elements
var entity_image_height : int  # used to position the combined aura elements

var element_names : Array[String] :
	set = set_element_names
var elements : Array[Element]
var element_registry : Dictionary

var element_remove_queue : Queue = Queue.new()
var combo_queue : Queue = Queue.new()


#=======================
# Setters
#=======================
func set_entity(new_entity : Variant) -> void:
	entity = new_entity
	self.position_aura()
	$Area2D.set("entity_instance_id", self.entity.get_instance_id())
	$AI.set("entity_instance_id" , self.entity.get_instance_id())
	$AI.set("entity_type", self.entity.entity_type)

func set_element_names(new_element_names : Array[String]) -> void:
	var old_element_names = self.element_names
	element_names = new_element_names
	$Area2D.set("element_names", new_element_names)
	$AI.set("element_names", new_element_names)

	if new_element_names.size() > old_element_names.size():
		BattleRadio.emit_signal(
			BattleRadio.ADD_ELEMENTS_ANIMATION_QUEUED,
			self.entity.get_instance_id(),
			self.get_added_element_names(new_element_names, old_element_names)
		)

#========================
# Aura Functionality
#========================
func get_added_element_names(
	new_element_names : Array[String],
	old_element_names : Array[String],
) -> Array[String]:
	var added_element_names : Array[String] = []

	var new_element_counter : Dictionary = {}
	for new_element_name in new_element_names:
		if not new_element_counter.has(new_element_name):
			new_element_counter[new_element_name] = 1
		else:
			new_element_counter[new_element_name] += 1

	var old_element_counter : Dictionary = {}
	for old_element_name in old_element_names:
		if not old_element_counter.has(old_element_name):
			old_element_counter[old_element_name] = 1
		else:
			old_element_counter[old_element_name] += 1

	for new_element_name in new_element_counter.keys():
		var new_element_count : int = new_element_counter.get(new_element_name)
		var old_element_count : int = old_element_counter.get(new_element_name, 0)
		var added_element_count : int = new_element_count - old_element_count
		for i in added_element_count:
			added_element_names.append(new_element_name)

	return added_element_names


#=====================
# Helpers
#=====================
func position_aura() -> void:
	var position_y : int = ((-1) * int(self.entity_image_height / 2.0) - 30)
	self.position.y = position_y
