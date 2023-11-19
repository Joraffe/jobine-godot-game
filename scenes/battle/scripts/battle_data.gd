extends Resource
class_name BattleData


var battle_arena_party_data : BattleArenaPartyData
var battle_arena_enemies_data : BattleArenaEnemiesData
var battle_field_hand_data : BattleFieldHandData
var battle_field_deck_data : BattleFieldDeckData
var battle_field_discard_data : BattleFieldDiscardData


func _init(_party_data, _enemies_data, _hand_data, _deck_data, _discard_data) -> void:
	battle_arena_party_data = _party_data
	battle_arena_enemies_data = _enemies_data
	battle_field_hand_data = _hand_data
	battle_field_deck_data = _deck_data
	battle_field_discard_data = _discard_data
