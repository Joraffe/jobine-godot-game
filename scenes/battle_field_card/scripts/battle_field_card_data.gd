extends Resource
class_name BattleFieldCardData


var card : Card


func _init(_name):
	card = CardArchive.get_card(_name)
