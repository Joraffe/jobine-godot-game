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
var background_name : String


func _init(seed_data : Dictionary, scene_data : Dictionary) -> void:
	var plan_party : Dictionary = scene_data[PlanConstants.PARTY]
	self.lead_character = plan_party[PlanConstants.LEAD]
	self.top_swap_character = plan_party[PlanConstants.STANDBY_TOP]
	self.bottom_swap_character = plan_party[PlanConstants.STANDBY_BOTTOM]
	self.enemies = BattleData.get_battle_enemies(seed_data)

	var plan_deck : Dictionary = scene_data[PlanConstants.DECK]
	var plan_cards : Array[Card] = []
	for character_name in plan_deck.keys():
		var character_cards : Array[Card] = plan_deck[character_name][PlanConstants.CARDS]
		plan_cards += character_cards
	self.cards = plan_cards

	self.discard_pile = BattleData.get_battle_discard_pile(seed_data)
	self.hand = BattleData.get_battle_hand(seed_data)
	self.max_hand_size = 5  # sticking this here in case want this to change
	self.max_energy = 3
	self.current_energy = 3
	self.background_name = "basic"


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

#	for i in range(2):
#		var rand_enemy_name = Enemy.get_random_enemy_machine_name()
#		battle_enemies.append(Enemy.create(enemy_seed_data[rand_enemy_name]))
	battle_enemies.append(Enemy.create(enemy_seed_data["ice_slime"]))
	battle_enemies.append(Enemy.create(enemy_seed_data["water_slime"]))

	battle_enemies[0].current_status_effects.append(
		StatusEffect.by_machine_name(StatusEffect.FROZEN, 1)
	)

	return battle_enemies

static func get_battle_cards(seed_data : Dictionary, character_instance_id_map : Dictionary) -> Array[Card]:
	var card_seed_data : Dictionary = seed_data[SeedData.CARDS]
#	{
#		"juno_character": [{ # juno card array }],
#		"pettol_character": [{ # pettol card array }],
#		"axo_character": [{ # axo card array }],
#	}
	var cards_data : Array[Dictionary] = []

	# iterate through all character cards
	for character_name in card_seed_data.keys():
		var character_instance_id : int = character_instance_id_map[character_name]
		var character_card_data : Array[Dictionary]
		character_card_data = card_seed_data[character_name]
		for card_data in character_card_data:
			card_data[Card.CHARACTER_INSTANCE_ID] = character_instance_id
		cards_data += character_card_data

	return Card.create_multi(cards_data)

static func get_battle_hand(_seed_data : Dictionary) -> Array[Card]:
	var battle_hand : Array[Card] = []
	return battle_hand

static func get_battle_discard_pile(_seed_data : Dictionary) -> Array[Card]:
	var battle_discard_pile : Array[Card] = []
	return battle_discard_pile
