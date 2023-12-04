extends Resource
class_name BattleFieldCardData


var card : Card
var available_energy : int


func _init(card_data : Dictionary, energy_data : Dictionary):
	card = Card.create(card_data)
	available_energy = energy_data[AVAILABLE_ENERGY]

func can_play() -> bool:
	return available_energy >= card.cost

const AVAILABLE_ENERGY : String = "available_energy"
