extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var character_namess : Array[String] = [
		CharacterArchive.JUNO_CHARACTER,
		CharacterArchive.PETTOL_CHARACTER,
		CharacterArchive.AXO_CHARACTER
	]
	var starter_cards : Dictionary = SeedData.get_starter_cards(character_namess)

	var characters_data : Array[BattleArenaCharacterData] = []
	for character_name in character_namess:
		var character_starter_cards : Array[Dictionary] = starter_cards[character_name]
		characters_data.append(
			BattleArenaCharacterData.new(
				character_name,
				character_starter_cards
			)
		)

	var party_data = BattleArenaPartyData.new(characters_data)
	var enemies_data = BattleArenaEnemiesData.new([
		BattleArenaEnemyData.new(EnemyArchive.get_random_enemy_name())
	])
	var hand_data = BattleFieldHandData.new([])
	var deck_data = BattleFieldDeckData.new(party_data.get_all_party_cards())
	var discard_data = BattleFieldDiscardData.new([])
	var essence_data = BattleFieldEssenceData.new([])
	battle_data = BattleData.new(
		party_data,
		enemies_data,
		hand_data,
		deck_data,
		discard_data,
		essence_data
	)


func _ready() -> void:
	BattleRadio.emit_signal("start_battle", battle_data)
