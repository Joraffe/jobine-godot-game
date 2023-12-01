extends Resource
class_name BattleFieldCardData


var card : Card


func _init(card_data):
	card = Card.create(card_data)
