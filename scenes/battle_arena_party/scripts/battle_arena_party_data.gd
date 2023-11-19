extends Resource
class_name BattleArenaPartyData


var party_members : Array[BattleArenaCharacterData]


func _init(_party_members : Array[BattleArenaCharacterData]):
	party_members = _party_members


func get_all_party_cards() -> Array[BattleFieldCardData]:
	var party_cards : Array[BattleFieldCardData] = []

	for party_member in party_members:
		for party_member_card in party_member.cards:
			party_cards.append(party_member_card)

	return party_cards
