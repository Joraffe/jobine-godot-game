extends Resource
class_name BattleArenaCharacterData


# public data
var character : Character


func _init(character_data : Dictionary):
	character = Character.create(character_data)
