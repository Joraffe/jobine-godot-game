extends Label

var character_name : String
var role : String :
	set = set_role


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_SELECTED, _on_roster_member_selected)
	PlanRadio.connect(PlanRadio.ROSTER_MEMBER_DESELECTED, _on_roster_member_deselected)


#=======================
# Setters
#=======================
func set_role(new_role : String) -> void:
	role = new_role

	self.text = self.role
	self.show()


#=======================
# Signal Handlers
#=======================
func _on_roster_member_selected(selected_name : String, selected_role : String) -> void:
	if selected_name != self.character_name:
		return

	self.set("role", selected_role)

func _on_roster_member_deselected(deselected_name : String, _deselected_role : String) -> void:
	if deselected_name != self.character_name:
		return

	self.hide()
