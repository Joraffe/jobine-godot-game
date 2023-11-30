extends Resource
class_name BattleData


var party_data : BattleArenaPartyData
var enemies_data : BattleArenaEnemiesData
var hand_data : BattleFieldHandData
var deck_data : BattleFieldDeckData
var swap_data : BattleFieldSwapData
var discard_data : BattleFieldDiscardData
var essence_data : BattleFieldEssenceData


func _init(
	_party_data : BattleArenaPartyData,
	_enemies_data : BattleArenaEnemiesData,
	_hand_data : BattleFieldHandData,
	_deck_data : BattleFieldDeckData,
	_swap_data : BattleFieldSwapData,
	_discard_data : BattleFieldDiscardData,
	_essence_data : BattleFieldEssenceData
) -> void:
	party_data = _party_data
	enemies_data = _enemies_data
	hand_data = _hand_data
	deck_data = _deck_data
	swap_data = _swap_data
	discard_data = _discard_data
	essence_data = _essence_data
