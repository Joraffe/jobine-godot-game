extends Resource
class_name PartyData


var party_members : Array[CharacterData] = []


func populate_party_members(characters : Array[CharacterData]):
	for character in characters:
		party_members.append(character)
