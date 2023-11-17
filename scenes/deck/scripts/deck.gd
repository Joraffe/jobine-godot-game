extends Node

var deck_data : DeckData = DeckData.new()
var image_data : ImageData = ImageData.new("deck", "pettel", "deck.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	deck_data.populate_deck([
		CardData.new(
			Characters.SCREM_PETTEL,
			ScremPettelCards.ATTACK
		),
		CardData.new(
			Characters.FLAT_PETTEL,
			FlatPettelCards.DEFEND
		),
		CardData.new(
			Characters.EVIL_PETTEL,
			EvilPettelCards.REDRAW
		)
	])
