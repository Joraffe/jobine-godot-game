extends Node2D


var party_data : PartyData = PartyData.new()
var image_data : ImageData = ImageData.new("party", "empty", "party.png")


func _init():
	BattleRadio.connect("start_battle", _on_start_battle)


func _on_start_battle():
	party_data.populate_party_members(
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
	)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
