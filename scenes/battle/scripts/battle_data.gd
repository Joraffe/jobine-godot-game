extends Resource
class_name BattleData


var lead_data : BattleArenaLeadData
var enemies_data : BattleArenaEnemiesData
var hand_data : BattleFieldHandData
var deck_data : BattleFieldDeckData
var swap_data : BattleFieldSwapData
var discard_data : BattleFieldDiscardData
var essence_data : BattleFieldEssenceData


func _init(
	_lead_data : BattleArenaLeadData,
	_enemies_data : BattleArenaEnemiesData,
	_hand_data : BattleFieldHandData,
	_deck_data : BattleFieldDeckData,
	_swap_data : BattleFieldSwapData,
	_discard_data : BattleFieldDiscardData,
	_essence_data : BattleFieldEssenceData
) -> void:
	lead_data = _lead_data
	enemies_data = _enemies_data
	hand_data = _hand_data
	deck_data = _deck_data
	swap_data = _swap_data
	discard_data = _discard_data
	essence_data = _essence_data

static func create(seed_data : Dictionary) -> BattleData:
	return BattleData.new(
		get_battle_arena_lead_data(seed_data),
		get_battle_arena_enemies_data(seed_data),
		get_battle_field_hand_data(seed_data),
		get_battle_field_deck_data(seed_data),
		get_battle_field_swap_data(seed_data),
		get_battle_field_discard_data(seed_data),
		get_battle_field_essence_data(seed_data)
	)


#=======================
# Data Helpers
#=======================
static func get_battle_arena_lead_data(seed_data : Dictionary) -> BattleArenaLeadData:	
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]

	# Juno starts off leading the party! :3
	return BattleArenaLeadData.new(
		character_seed_data[CharacterArchive.JUNO_CHARACTER]
	)

static func get_battle_arena_enemies_data(_seed_data : Dictionary) -> BattleArenaEnemiesData:
	return BattleArenaEnemiesData.new([
		BattleArenaEnemyData.new(
			EnemyArchive.get_random_enemy_name()
		)
	])

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
	return BattleFieldDiscardData.new([])

static func get_battle_field_essence_data(_seed_data : Dictionary) -> BattleFieldEssenceData:
	return BattleFieldEssenceData.new([])
