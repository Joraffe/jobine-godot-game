extends Resource
class_name DeckData


var deck_cards : Dictionary
var rng = RandomNumberGenerator.new()


func populate_deck(cards : Array[CardData]):
	print('cards ', cards)
	var indexes : Dictionary = {}
	for i in cards.size():
		indexes[i] = i

	while indexes.keys().size() > 0:
		var keys = indexes.keys()
		var rand_i = rng.randi_range(0, keys.size() - 1)
		var rand_key = keys[rand_i]
		deck_cards[rand_key] = cards[rand_key]
		indexes.erase(rand_key)


func draw_card():
	var keys = deck_cards.keys()
	
	if keys.size() == 0:
		return ""

	var rand_key = keys[rng.randi_range(0, keys.size() - 1)]
	var card = deck_cards[rand_key]
	deck_cards.erase(rand_key)
	
	return card
