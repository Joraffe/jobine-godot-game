extends Resource
class_name HandData


var hand : Array[CardData]


func _init(_hand : Array[CardData]) -> void:
	hand = _hand


func get_current_hand() -> Array[CardData]:
	return hand
