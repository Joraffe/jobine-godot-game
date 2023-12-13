extends Node2D


var aura_element_scene : PackedScene = preload(
	"res://scenes/battle_arena_aura_element/BattleArenaAuraElement.tscn"
)

var entity  # used to associate this with an character/enemy
var aura_width : int  # used to position the aura element
var element_registry : Dictionary = {}
var elements : Array[Element] = []

var first_combining_element : Element = Element.Empty()
var second_combining_element : Element = Element.Empty()


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	$Timer.connect("timeout", _on_elements_finished_animating)


#========================
# Signal Handlers
#========================
func _on_elements_finished_animating() -> void:
	var combo : Combo = Combo.create({
		Combo.FIRST_ELEMENT : self.first_combining_element,
		Combo.SECOND_ELEMENT : self.second_combining_element
	})
	print('Aura.about to emit_sigal for COMBO_APPLIED')
	print('entity_id ', self.entity.get_instance_id())
	print('entity name ', self.entity.machine_name)
	print('combo ', combo.machine_name)
	BattleRadio.emit_signal(
		BattleRadio.COMBO_APPLIED,
		self.entity.get_instance_id(),
		combo
	)
	reset_combining_elements()

#========================
# Aura Functionality
#========================
func apply_element(element : Element) -> void:
	elements.append(element)
	register_element(element)
	var instance = instantiate_aura_element(element)
	position_aura_element(instance, num_elements_applied() - 1)
	var combo_data : Dictionary = check_for_combo()
	if not combo_data.is_empty():
		var first_element_index = combo_data[Combo.FIRST_ELEMENT_INDEX]
		var second_element_index = combo_data[Combo.SECOND_ELEMENT_INDEX]
		first_combining_element = self.elements[first_element_index]
		second_combining_element = self.elements[second_element_index]
		clean_up_combined_elements(first_element_index, second_element_index)
		$Timer.start()

func register_element(element : Element) -> void:
	if not element_registry.has(element.machine_name):
		element_registry[element.machine_name] = 1
	elif element_registry.has(element.machine_name):
		element_registry[element.machine_name] += 1

func unregister_element(element : Element) -> void:
	if element_registry[element.machine_name] == 1:
		element_registry.erase(element.machine_name)
	elif element_registry[element.machine_name] > 1:
		element_registry[element.machine_name] -= 1

func num_elements_applied() -> int:
	var num_elements : int = 0
	for key in element_registry.keys():
		var element_amount : int = element_registry[key]
		num_elements += element_amount
	return num_elements

func has_multiple_distinct_elements() -> bool:
	return element_registry.keys().size() >= 2

func check_for_combo() -> Dictionary:
	# Need at least 2 diff elements to combine
	if not has_multiple_distinct_elements():
		return {}

	var combo_data : Dictionary = {}

	for index in elements.size():
		combo_data  = check_index_for_combo(index)
		if not combo_data.is_empty():
			break

	return combo_data

func check_index_for_combo(element_index : int) -> Dictionary:
	var element : Element = self.elements[element_index] 

	for compared_index in range(0, elements.size() - 1):
		if compared_index == element_index:
			continue

		var compared_element : Element = self.elements[compared_index]
		var potential_combo : Combo = Combo.create({
			Combo.FIRST_ELEMENT : element,
			Combo.SECOND_ELEMENT : compared_element
		})
		if potential_combo.has_reaction():
			return {
				Combo.FIRST_ELEMENT_INDEX : element_index,
				Combo.SECOND_ELEMENT_INDEX : compared_index
			}

	return {}

func clean_up_combined_elements(first_index : int, second_index : int) -> void:	
	var new_elements : Array[Element] = []
	for i in range(0, self.elements.size() - 1):
		if i not in [first_index, second_index]:
			var element : Element = self.elements[i]
			new_elements.append(element)

	for i in [first_index, second_index]:
		var element : Element = self.elements[i]
		unregister_element(element)
		tween_up_and_free_element(element)

	elements = new_elements
	reposition_remaining_aura_elements()

func reset_combining_elements() -> void:
	first_combining_element = Element.Empty()
	second_combining_element = Element.Empty()


#=====================
# Data Helpers
#=====================
func instantiate_aura_element(element : Element) -> Node2D:
	var instance = aura_element_scene.instantiate()
	instance.set("element", element)
	add_child(instance)
	return instance


#=====================
# Node Helpers
#=====================
func get_aura_element_position_x(instance : Node2D, position_index : int) -> int:
	var aura_element_width : int = instance.image_data.get_img_width()
	var starting_x : int = (-1 * int(aura_width / 2.0)) + int(aura_element_width / 2.0)
	var offset_x : int = (position_index * aura_element_width) + (position_index * 10)
	return starting_x + offset_x

func position_aura_element(instance : Node2D, position_index : int) -> void:
	var position_x = get_aura_element_position_x(instance, position_index)
	instance.position.x = position_x

func tween_to_aura_element_position(instance : Node2D, position_index : int) -> void:
	var position_x = get_aura_element_position_x(instance, position_index)
	var tween = create_tween()
	tween.tween_property(
		instance,
		"position",
		Vector2(position_x, instance.position.y),
		0.75
	)

func reposition_remaining_aura_elements():
	for i in elements.size():
		for child in self.get_children():
			if child.get("element") == elements[i]:
				tween_to_aura_element_position(child, i)

func tween_up_and_free_element(element : Element) -> void:
	for child in get_children():
		if child.get("element") == element:
			var tween = child.create_tween()
			var sprite_2d = child.get_node("Area2D/Sprite2D")
			var cur_position = sprite_2d.position
			var new_position = Vector2(cur_position.x, cur_position.y - 50)
			tween.tween_property(
				sprite_2d,
				"position",
				new_position,
				0.5
			)
			tween.tween_callback(child.queue_free)
