extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var seed_data = SeedData.get_seed_data()

	var lead_data : BattleArenaLeadData
	lead_data = get_battle_arena_lead_data(seed_data)

	var enemies_data = BattleArenaEnemiesData.new([
		BattleArenaEnemyData.new(EnemyArchive.get_random_enemy_name())
	])
	var hand_data = BattleFieldHandData.new([])
	
	var deck_data : BattleFieldDeckData
	deck_data = get_battle_field_deck_data(seed_data)
	
	var swap_data : BattleFieldSwapData
	swap_data = get_battle_field_swap_data(seed_data)

	var discard_data = BattleFieldDiscardData.new([])
	var essence_data = BattleFieldEssenceData.new([])
	battle_data = BattleData.new(
		lead_data,
		enemies_data,
		hand_data,
		deck_data,
		swap_data,
		discard_data,
		essence_data
	)


func _ready() -> void:
	BattleRadio.emit_signal("battle_started", battle_data)


#=======================
# Data Helpers
#=======================
func get_battle_arena_lead_data(seed_data : Dictionary) -> BattleArenaLeadData:	
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]

	# Juno starts off leading the party! :3
	return BattleArenaLeadData.new(
		character_seed_data[CharacterArchive.JUNO_CHARACTER]
	)

func get_battle_field_deck_data(seed_data : Dictionary) -> BattleFieldDeckData:
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

func get_battle_field_swap_data(seed_data : Dictionary) -> BattleFieldSwapData:
	var character_seed_data : Dictionary = seed_data[SeedData.CHARACTERS]
	
	return BattleFieldSwapData.new(
		character_seed_data[CharacterArchive.JUNO_CHARACTER],
		character_seed_data[CharacterArchive.AXO_CHARACTER],
		character_seed_data[CharacterArchive.PETTOL_CHARACTER]
	)
