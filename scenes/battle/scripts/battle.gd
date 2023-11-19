extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	var party_data = BattleArenaPartyData.new([
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
	])
	var enemies_data = BattleArenaEnemiesData.new([
		BattleArenaEnemyData.new(EnemyArchive.BABY_AXO)
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
