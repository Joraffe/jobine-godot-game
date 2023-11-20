extends Resource
class_name Card


var name : String
var cost : int  # how much it cost to play this card
var element : Element
var tokens : Array[Token]
var targeting : Targeting


func _init(
	_name : String,
	_cost : int,
	_element_name : String,
	_targeting_name : String,
	_token_names : Array[String]
) -> void:
	name = _name
	cost = _cost
	element = ElementArchive.get_element(_element_name)
	targeting = TargetingArchive.get_targeting(_targeting_name)
	tokens = TokenArchive.get_tokens(_token_names)
