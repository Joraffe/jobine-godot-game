extends Resource
class_name ElementArchive


static func get_element(name : String) -> Element:
	match name:
		FIRE_ELEMENT:
			return Element.new(FIRE_ELEMENT)
		WATER_ELEMENT:
			return Element.new(WATER_ELEMENT)
		NATURE_ELEMENT:
			return Element.new(NATURE_ELEMENT)
		_:
			return Element.new(UNKNOWN_ELEMENT)


#=========================
#      Element Types
#=========================
const FIRE_ELEMENT : String = "fire"
const WATER_ELEMENT : String = "water"
const NATURE_ELEMENT : String = "nature"
const UNKNOWN_ELEMENT : String = "unknown_element"
