extends Area2D


var is_mouse_over : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Do something with these later, perhaps animating
func _on_mouse_entered():
	is_mouse_over = true


func _on_mouse_exited():
	is_mouse_over = false
