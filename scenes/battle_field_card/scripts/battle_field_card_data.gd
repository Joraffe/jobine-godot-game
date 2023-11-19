extends Resource
class_name BattleFieldCardData


var character : String
var name : String


func _init(_character, _name):
	character = _character
	name = _name


static func create_from_dict(card_data_dict : Dictionary) -> BattleFieldCardData:
	return BattleFieldCardData.new(
		card_data_dict["character"],
		card_data_dict["name"]
	)
