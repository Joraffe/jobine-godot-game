extends Resource
class_name Character


var name : String
var element : Element
var max_hp : int
var current_hp : int


func _init(
	_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int
):
	name = _name
	element = ElementArchive.get_element(_element_name)
	max_hp = _max_hp
	current_hp = _current_hp
