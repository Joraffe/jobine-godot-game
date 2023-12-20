extends Node


var entity : Variant
var element_names : Array[String] :
	set = set_element_names


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(
		BattleRadio.ELEMENT_NAMES_ADDED_TO_ENTITY,
		_on_element_names_added_to_entity
	)
	BattleRadio.connect(
		BattleRadio.ELEMENT_NAMES_REMOVED_FROM_ENTITY,
		_on_element_names_removed_from_entity
	)


#=======================
# Setters
#=======================
func set_element_names(new_element_names : Array[String]) -> void:
	var old_element_names : Array[String] = self.element_names
	element_names = new_element_names

	if new_element_names > old_element_names:
		BattleRadio.emit_signal(
			BattleRadio.ELEMENT_NAMES_ADDED_TO_ENTITY_RESOLVED,
			self.entity.get_instance_id()
		)
	elif new_element_names < old_element_names:
		BattleRadio.emit_signal(
			BattleRadio.ELEMENT_NAMES_REMOVED_FROM_ENTITY_RESOLVED,
			self.entity.get_instance_id()
		)


#=======================
# Signal Handlers
#=======================
func _on_element_names_added_to_entity(added_element_names : Array[String]) -> void:
	self.set(
		"element_names",
		self.element_names + added_element_names
	)

func _on_element_names_removed_from_entity(removed_element_names : Array[String]) -> void:
	self.set(
		"element_names",
		ArrayUtils.difference(self.element_names, removed_element_names)
	)
