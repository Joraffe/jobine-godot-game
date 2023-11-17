extends Resource
class_name PartyData


var party_members : Array[CharacterData]


func _init(_party_members : Array[CharacterData]):
	party_members = _party_members


func get_all_party_cards() -> Array[CardData]:
	var party_cards : Array[CardData] = []

	for party_member in party_members:
		for party_member_card in party_member.cards:
			party_cards.append(party_member_card)

	return party_cards
