extends Resource
class_name BattleData


var lead_data : BattleArenaLeadData
var enemies_data : BattleArenaEnemiesData
var hand_data : BattleFieldHandData
var deck_data : BattleFieldDeckData
var swap_data : BattleFieldSwapData
var discard_data : BattleFieldDiscardData
var energy_data : BattleFieldEnergyData


func _init(seed_data : Dictionary) -> void:
	lead_data = BattleData.get_battle_arena_lead_data(seed_data)
	enemies_data = BattleData.get_battle_arena_enemies_data(seed_data)
	hand_data = BattleData.get_battle_field_hand_data(seed_data)
	deck_data = BattleData.get_battle_field_deck_data(seed_data)
	swap_data = BattleData.get_battle_field_swap_data(seed_data)
	discard_data = BattleData.get_battle_field_discard_data(seed_data)
	energy_data = BattleData.get_battle_field_energy_data(seed_data)


#=======================
# Data Helpers
#=======================
static func get_battle_arena_lead_data(seed_data : Dictionary) -> BattleArenaLeadData:	
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]

	# Juno starts off leading the party! :3
	return BattleArenaLeadData.new(
		character_seed_data[CharacterArchive.JUNO_CHARACTER]
	)

static func get_battle_arena_enemies_data(seed_data : Dictionary) -> BattleArenaEnemiesData:
	var rand_enemy_name = EnemyArchive.get_random_enemy_name()
	var enemy_seed_data : Dictionary = seed_data[SeedData.ENEMIES]

	# For now just 1 enemy, but will change in the future 
	# with actual playtesting against multiple enemies! :3
	return BattleArenaEnemiesData.new([enemy_seed_data[rand_enemy_name]])

static func get_battle_field_deck_data(seed_data : Dictionary) -> BattleFieldDeckData:
	var card_seed_data : Dictionary = seed_data[SeedData.CARDS]
#	{
#		"juno_character": [{ # juno card array }],
#		"pettol_character": [{ # pettol card array }],
#		"axo_character": [{ # axo card array }],
#	}
	var cards_data : Array[Dictionary] = []

	# iterate through all character cards
	for character_name in card_seed_data.keys():
		var character_cards_data : Array[Dictionary]
		character_cards_data = card_seed_data[character_name]
		for character_card_data in character_cards_data:
			cards_data.append(character_card_data)

	return BattleFieldDeckData.new(cards_data)

static func get_battle_field_hand_data(_seed_data : Dictionary) -> BattleFieldHandData:
	return BattleFieldHandData.new([])

static func get_battle_field_swap_data(seed_data : Dictionary) -> BattleFieldSwapData:
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]
	
	return BattleFieldSwapData.new(
		character_seed_data[CharacterArchive.JUNO_CHARACTER],
		character_seed_data[CharacterArchive.AXO_CHARACTER],
		character_seed_data[CharacterArchive.PETTOL_CHARACTER]
	)

static func get_battle_field_discard_data(_seed_data : Dictionary) -> BattleFieldDiscardData:
	var discard_pile : Array[Dictionary] = []

	return BattleFieldDiscardData.new({
		BattleFieldDiscardData.DISCARD_PILE : discard_pile
	})

static func get_battle_field_energy_data(_seed_data : Dictionary) -> BattleFieldEnergyData:
	return BattleFieldEnergyData.new({
		BattleFieldEnergyData.MAX_ENERGY: 3,
		BattleFieldEnergyData.CURRENT_ENERGY: 3
	})
