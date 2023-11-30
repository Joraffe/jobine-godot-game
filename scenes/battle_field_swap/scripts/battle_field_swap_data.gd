extends Resource
class_name BattleFieldSwapData


const TOP : String = "swap_member_top"
const BOTTOM : String = "swap_member_bottom"
const ACTIVE : String = "active_member"


var members : Dictionary



func _init(_members : Dictionary) -> void:
	members = _members
