extends Resource
class_name Combiner


var element_names : Array[String] :
	set = set_element_names
var owner_instance_id : int

var registry : Dictionary

var remove_indexes : Array[int]
var remaining_indexes : Array[int]

var current_combo : Combo



#=======================
# Godot Lifecycle Hooks
#=======================
func _init(
	_element_names : Array[String],
	_owner_instance_id : int,
) -> void:
	self.set("owner_instance_id", _owner_instance_id)
	self.set("element_names", _element_names)


#=======================
# Setters
#=======================
func set_element_names(new_element_names : Array[String]) -> void:
	element_names = new_element_names
	self.register_elements()
	self.calculate()


#=======================
# Internal Logic
#=======================
func has_multiple_distince_elements():
	return self.registry.keys().size() > 1

func register_elements() -> void:
	var new_element_registry : Dictionary = {}

	for element_name in self.element_names:
		if not new_element_registry.has(element_name):
			new_element_registry[element_name] = 1
		else:
			new_element_registry[element_name] += 1

	self.set("registry", new_element_registry)

func calc_remaining(indexes_to_remove : Array[int]) -> Array[int]:
	var indexes_to_remain : Array[int] = []

	for i in self.element_names.size():
		if not i in indexes_to_remove:
			indexes_to_remain.append(i)

	return indexes_to_remain


#=======================
# Public Interface
#=======================
func calculate() -> void:
	if not self.has_multiple_distince_elements():
		var blank_indexes : Array[int] = []
		self.set("remove_indexes", blank_indexes)
		self.set("remaining_indexes", self.calc_remaining(blank_indexes))
		self.set("current_combo", Combo.Empty())
		return

	for element_index in self.element_names.size():
		var element_name = self.element_names[element_index]
		for compared_index in range(element_index + 1, self.element_names.size()):
			var compared_element_name = self.element_names[compared_index]
			var potential_combo : Combo = Combo.create({
				Combo.FIRST_ELEMENT : Element.by_machine_name(element_name),
				Combo.SECOND_ELEMENT : Element.by_machine_name(compared_element_name)
			})
			var indexes_to_remove : Array[int] = [element_index, compared_index]
			if potential_combo.has_reaction():
				self.set("current_combo", potential_combo)
				self.set("remove_indexes", indexes_to_remove)
				self.set("remaining_indexes", self.calc_remaining(self.remove_indexes))
				self.set("combo_first_element_name", element_name)
				self.set("combo_second_element_name", compared_element_name)
				return

func has_combo() -> bool:
	# there's a couple of ways to determine this
	# but this is a simple convenient way
	return self.remove_indexes.size() > 0

func has_remaining_elements() -> bool:
	return self.remaining_indexes.size() > 0


#=======================
# Constants
#=======================
const FIRST_ELEMENT_INDEX : String = "first_element_index"
const FIRST_ELEMENT_NAME : String = "first_element_name"
const SECOND_ELEMENT_INDEX : String = "second_element_index"
const SECOND_ELEMENT_NAME : String = "second_element_name"
