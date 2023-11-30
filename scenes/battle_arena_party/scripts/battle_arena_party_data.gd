extends Resource
class_name BattleArenaPartyData


var party_members : Array[BattleArenaCharacterData]
var active_party_member : BattleArenaCharacterData


func _init(
	_party_members : Array[BattleArenaCharacterData],
	_active_party_member: BattleArenaCharacterData
):
	party_members = _party_members
	active_party_member = _active_party_member


func get_all_party_cards() -> Array[BattleFieldCardData]:
	var party_cards : Array[BattleFieldCardData] = []

	for party_member in party_members:
		for party_member_card in party_member.cards:
			party_cards.append(party_member_card)

	return party_cards
