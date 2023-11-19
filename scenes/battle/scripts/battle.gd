extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var battle_arena_party_data = BattleArenaPartyData.new(
		[
			BattleArenaCharacterData.new(
				CharacterArchive.SCREM_PETTEL,
				ScremPettelCards.get_starter_cards()
			),
			BattleArenaCharacterData.new(
				CharacterArchive.EVIL_PETTEL,
				EvilPettelCards.get_starter_cards()
			),
			BattleArenaCharacterData.new(
				CharacterArchive.FLAT_PETTEL,
				FlatPettelCards.get_starter_cards()
			)
		]
	)
	var battle_arena_enemies_data = BattleArenaEnemiesData.new(
		[
			BattleArenaEnemyData.new(EnemyArchive.BABY_AXO)
		]
	)
	var battle_field_hand_data = BattleFieldHandData.new([])
	var battle_field_deck_data = BattleFieldDeckData.new(
		battle_arena_party_data.get_all_party_cards()
	)
	var battle_field_discard_data = BattleFieldDiscardData.new([])
	battle_data = BattleData.new(
		battle_arena_party_data,
		battle_arena_enemies_data,
		battle_field_hand_data,
		battle_field_deck_data,
		battle_field_discard_data
	)


func _ready() -> void:
	BattleRadio.emit_signal("start_battle", battle_data)
