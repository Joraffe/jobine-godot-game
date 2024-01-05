extends Area2D


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


#=======================
# Signal Handlers
#=======================
func _on_mouse_entered() -> void:
	HubRadio.emit_signal(HubRadio.MOUSE_ENTERED_EXPANDED_DATETIME)

func _on_mouse_exited() -> void:
	HubRadio.emit_signal(HubRadio.MOUSE_EXITED_EXPANDED_DATETIME)
