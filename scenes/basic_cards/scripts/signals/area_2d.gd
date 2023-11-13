extends Area2D


signal mouse_hover
signal mouse_unhover


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	mouse_hover.emit()


func _on_mouse_exited():
	mouse_unhover.emit()
