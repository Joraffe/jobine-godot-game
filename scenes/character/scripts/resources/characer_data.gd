extends Resource
class_name CharacterData

var name : String
var cards : Array[CardData]


func _init(_name, _cards):
	name = _name
	cards = _cards
