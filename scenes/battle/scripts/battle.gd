extends Node2D


var battle_data : BattleData


#=======================
# Godot Lifecycle Hooks
#=======================
func _init():
	battle_data = BattleData.new(
		PartyData.new(
			[
				CharacterData.new(
					Characters.SCREM_PETTEL,
					ScremPettelCards.get_starter_cards()
				),
				CharacterData.new(
					Characters.EVIL_PETTEL,
					EvilPettelCards.get_starter_cards()
				),
				CharacterData.new(
					Characters.FLAT_PETTEL,
					FlatPettelCards.get_starter_cards()
				)
			]
		),
		EnemiesData.new(
			[
				EnemyData.new(EnemyArchive.BABY_AXO)
			]
		),
		HandData.new([])
	)


func _ready():
	BattleRadio.emit_signal("start_battle", battle_data)
