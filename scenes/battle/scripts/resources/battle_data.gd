extends Resource
class_name BattleData


var party_data : PartyData
var hand_data : HandData


func _init(_party_data, _hand_data) -> void:
	party_data = _party_data
	hand_data = _hand_data


func get_all_party_cards() -> Array[CardData]:
	var party_cards : Array[CardData]

	for party_member in party_data.party_members:
		for party_member_card in party_member.cards:
			party_cards.append(party_member_card)
	
	return party_cards


func is_hand_full() -> bool:
	var hand_size = hand_data.hand.size()

	return hand_size >= 5
