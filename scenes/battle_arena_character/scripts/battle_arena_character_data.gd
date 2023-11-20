extends Resource
class_name BattleArenaCharacterData

var name : String
var cards : Array[BattleFieldCardData]


func _init(_name : String, _card_dicts : Array[Dictionary]):
	name = _name
	cards = create_cards_from_dicts(_card_dicts)


func create_cards_from_dicts(card_dicts : Array[Dictionary]) -> Array[BattleFieldCardData]:
	var new_cards : Array[BattleFieldCardData] = []
	for card_dict in card_dicts:
		new_cards.append(BattleFieldCardData.create_from_dict(card_dict))
	
	return new_cards
