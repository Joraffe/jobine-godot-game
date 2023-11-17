extends Resource
class_name BattleData


var party_data : PartyData
var enemies_data : EnemiesData
var hand_data : HandData


func _init(_party_data, _enemies_data, _hand_data) -> void:
	party_data = _party_data
	enemies_data = _enemies_data
	hand_data = _hand_data
