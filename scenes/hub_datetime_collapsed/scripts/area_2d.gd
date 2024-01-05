extends Area2D


var is_mouse_over_datetime : bool


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
	self.set("is_mouse_over_datetime", true)

func _on_mouse_exited() -> void:
	self.set("is_mouse_over_datetime", false)

func _input(event) -> void:
	if not self.is_mouse_over_datetime:
		return

	if not self.is_left_mouse_click(event):
		return

	if self.is_left_mouse_click(event):
		self.emit_collapsed_datetime_clicked()
		return

#=======================
# Helpers
#=======================
func is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

func emit_collapsed_datetime_clicked() -> void:
	HubRadio.emit_signal(HubRadio.COLLAPSED_DATETIME_CLICKED)
