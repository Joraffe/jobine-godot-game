extends Resource
class_name BattleArenaData


var is_card_selected : bool


func _init(battle_arena_data : Dictionary) -> void:
	is_card_selected = battle_arena_data[IS_CARD_SELECTED]

const IS_CARD_SELECTED : String = "is_card_selected"
