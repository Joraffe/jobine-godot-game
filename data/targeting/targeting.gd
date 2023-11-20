extends Resource
class_name Targeting


var group : String
var number : int
var all : bool


func _init(
	_group : String,
	_number : int,
	_all : bool
) -> void:
	group = _group
	number = _number
	all = _all
