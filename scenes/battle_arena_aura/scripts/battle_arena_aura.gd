extends Node2D


var num_elements_applied : int = 0

var first_element : Element:
	set = set_first_element
var second_element : Element:
	set = set_second_element
var third_element : Element:
	set = set_third_element


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass


#=======================
# Setters
#=======================
func set_first_element(new_element : Element) -> void:
	first_element = new_element
	num_elements_applied += 1
	$FirstAuraElement.set("element", first_element)

func set_second_element(new_element : Element) -> void:
	second_element = new_element
	num_elements_applied += 1
	$SecondAuraElement.set("element", second_element)

func set_third_element(new_element : Element) -> void:
	third_element = new_element
	num_elements_applied += 1
	$ThirdAuraElement.set("element", third_element)


#========================
# Aura Functionality
#========================
func apply_element(element : Element) -> void:
	match num_elements_applied:
		0:
			set_first_element(element)
		1:
			set_second_element(element)
		2:
			set_third_element(element)
		_:
			return
