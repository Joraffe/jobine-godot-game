extends Resource
class_name BattleData


var lead_character : Character
var top_swap_character : Character
var bottom_swap_character : Character
var enemies : Array[Enemy]
var cards : Array[Card]
var discard_pile : Array[Card]
var hand : Array[Card]
var max_hand_size : int
var max_energy : int
var current_energy : int


func _init(seed_data : Dictionary) -> void:
	lead_character = BattleData.get_battle_lead_character(seed_data)
	top_swap_character = BattleData.get_battle_top_swap_character(seed_data)
	bottom_swap_character = BattleData.get_battle_bottom_swap_character(seed_data)
	enemies = BattleData.get_battle_enemies(seed_data)
	cards = BattleData.get_battle_cards(seed_data)
	discard_pile = BattleData.get_battle_discard_pile(seed_data)
	hand = BattleData.get_battle_hand(seed_data)
	max_hand_size = 5  # sticking this here in case want this to change
	max_energy = 3
	current_energy = 3


#=======================
# Data Helpers
#=======================
static func get_battle_lead_character(seed_data : Dictionary) -> Character:	
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]
	# Juno starts off leading the party! :3
	return Character.create(character_seed_data[Character.JUNO])

static func get_battle_top_swap_character(seed_data : Dictionary) -> Character:
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]
	return Character.create(character_seed_data[Character.PETTOL])

static func get_battle_bottom_swap_character(seed_data : Dictionary) -> Character:
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]
	return Character.create(character_seed_data[Character.AXO])

static func get_battle_enemies(seed_data : Dictionary) -> Array[Enemy]:
	var battle_enemies : Array[Enemy] = []
	var enemy_seed_data : Dictionary = seed_data[SeedData.ENEMIES]

	# For now just 1 enemy, but will change in the future 
	# with actual playtesting against multiple enemies! :3
	var rand_enemy_name = Enemy.get_random_enemy_machine_name()
	battle_enemies.append(Enemy.create(enemy_seed_data[rand_enemy_name]))

	return battle_enemies

static func get_battle_cards(seed_data : Dictionary) -> Array[Card]:
	var card_seed_data : Dictionary = seed_data[SeedData.CARDS]
#	{
#		"juno_character": [{ # juno card array }],
#		"pettol_character": [{ # pettol card array }],
#		"axo_character": [{ # axo card array }],
#	}
	var card_names : Array[String] = []

	# iterate through all character cards
	for character_name in card_seed_data.keys():
		var character_card_names : Array[String]
		character_card_names = card_seed_data[character_name]
		for character_card_name in character_card_names:
			card_names.append(character_card_name)

	return Card.by_machine_names(card_names)

static func get_battle_hand(_seed_data : Dictionary) -> Array[Card]:
	var battle_hand : Array[Card] = []
	return battle_hand

static func get_battle_discard_pile(_seed_data : Dictionary) -> Array[Card]:
	var battle_discard_pile : Array[Card] = []
	return battle_discard_pile
