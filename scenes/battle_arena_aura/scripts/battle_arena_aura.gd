extends Node2D


var aura_element_scene : PackedScene = preload(
	"res://scenes/battle_arena_aura_element/BattleArenaAuraElement.tscn"
)

var entity  # used to associate this with an character/enemy
var aura_width : int  # used to position the aura element
var element_registry : Dictionary = {}
var elements : Array[Element] = []


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ELEMENTS_COMBINED, _on_elements_combined)


#=======================
# Signal Handlers
#=======================
func _on_elements_combined(combo_data : Dictionary) -> void:
	if combo_data[Combo.ENTITY] != entity:
		return

	var first_combo_index = combo_data[Combo.FIRST_ELEMENT][Combo.INDEX]
	var first_combo_element = combo_data[Combo.FIRST_ELEMENT][Combo.ELEMENT]
	var second_combo_index = combo_data[Combo.SECOND_ELEMENT][Combo.INDEX]
	var second_combo_element = combo_data[Combo.SECOND_ELEMENT][Combo.ELEMENT]

	var new_elements : Array[Element] = []
	for i in elements.size():
		if i not in [first_combo_index, second_combo_index]:
			new_elements.append(elements[i])

	elements = new_elements
	unregister_element(first_combo_element)
	unregister_element(second_combo_element)
	tween_up_and_free_element(first_combo_element)
	tween_up_and_free_element(second_combo_element)
	reposition_remaining_aura_elements()

	await get_tree().create_timer(0.5).timeout
	BattleRadio.emit_signal(BattleRadio.COMBO_APPLIED, combo_data)

#========================
# Aura Functionality
#========================
func apply_element(element : Element) -> void:
	elements.append(element)
	register_element(element)
	var instance = instantiate_aura_element(element)
	position_aura_element(instance, num_elements_applied() - 1)
	check_for_combo()

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

func check_for_combo() -> void:
	var combo_data : Dictionary = {}

	# Need at least 2 diff elements to combine
	if not has_multiple_distinct_elements():
		return

	for index in elements.size():
		combo_data  = check_index_for_combo(index)
		if combo_data[Combo.COMBO]:
			BattleRadio.emit_signal(
				BattleRadio.ELEMENTS_COMBINED,
				combo_data
			)
			break

func check_index_for_combo(element_index : int) -> Dictionary:
	var combo_data : Dictionary = {
		Combo.ENTITY: null,
		Combo.FIRST_ELEMENT: null,
		Combo.SECOND_ELEMENT: null,
		Combo.COMBO: null
	}

	var element : Element = elements[element_index]

	for compared_index in elements.size():
		if compared_index == element_index:
			continue

		var compared_element : Element = elements[compared_index]
		if is_same_element(element, compared_element):
			continue

		combo_data[Combo.ENTITY] = entity
		combo_data[Combo.FIRST_ELEMENT] = {
			Combo.INDEX : element_index,
			Combo.ELEMENT : element
		}
		combo_data[Combo.SECOND_ELEMENT] = {
			Combo.INDEX : compared_index,
			Combo.ELEMENT: compared_element
		}

		if is_evaporate_combo(element, compared_element):
			combo_data[Combo.COMBO] = Combo.Evaporate()
			return combo_data

		if is_burn_combo(element, compared_element):
			combo_data[Combo.COMBO] = Combo.Burn()
			return combo_data

		if is_grow_combo(element, compared_element):
			combo_data[Combo.COMBO] = Combo.Grow()
			return combo_data

	# if we make it here, the element at the index
	# we are checking cannot combine with any others
	return {
		Combo.ENTITY : null,
		Combo.FIRST_ELEMENT: null,
		Combo.SECOND_ELEMENT: null,
		Combo.COMBO: null
	}

#======================
# Data Helpers
#=====================
func instantiate_aura_element(element : Element) -> Node2D:
	var instance = aura_element_scene.instantiate()
	instance.set("element", element)
	add_child(instance)
	return instance

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

func is_same_element(first_element : Element, second_element : Element) -> bool:
	return first_element.machine_name == second_element.machine_name

func is_evaporate_combo(first_element : Element, second_element : Element) -> bool:
	return (
		(_is_fire_element(first_element) and _is_water_element(second_element))
		or (_is_water_element(first_element) and _is_fire_element(second_element))
	)

func is_grow_combo(first_element : Element, second_element : Element) -> bool:
	return (
		(_is_nature_element(first_element) and _is_water_element(second_element))
		or (_is_water_element(first_element) and _is_nature_element(second_element))
	)

func is_burn_combo(first_element : Element, second_element : Element) -> bool:
	return (
		(_is_fire_element(first_element) and _is_nature_element(second_element))
		or (_is_nature_element(first_element) and _is_fire_element(second_element))
	)

func _is_fire_element(element : Element) -> bool:
	return element.machine_name == Element.FIRE

func _is_water_element(element : Element) -> bool:
	return element.machine_name == Element.WATER

func _is_nature_element(element : Element) -> bool:
	return element.machine_name == Element.NATURE
