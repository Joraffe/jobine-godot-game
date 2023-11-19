extends Resource
class_name BattleFieldDeckData


var rng = RandomNumberGenerator.new()

var cards : Array[BattleFieldCardData]
var shuffled_cards : Dictionary
var can_draw_cards : bool


func _init(_cards : Array[BattleFieldCardData]) -> void:
	cards = _cards
	can_draw_cards = true
	shuffle_cards()


func has_cards() -> bool:
	return shuffled_cards.size() != 0


func shuffle_cards() -> void:
	var indexes : Dictionary = {}
	for i in cards.size():
		indexes[i] = i

	while indexes.keys().size() > 0:
		var keys = indexes.keys()
		var rand_i = rng.randi_range(0, keys.size() - 1)
		var rand_key = keys[rand_i]
		shuffled_cards[rand_key] = cards[rand_key]
		indexes.erase(rand_key)


func draw_card() -> BattleFieldCardData:
	var keys = shuffled_cards.keys()
	var rand_key = keys[rng.randi_range(0, keys.size() - 1)]
	var card = shuffled_cards[rand_key]
	shuffled_cards.erase(rand_key)
	
	return card
