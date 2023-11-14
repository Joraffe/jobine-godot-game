extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Area2D".connect("mouse_hover", show_label)
	$"../../Area2D".connect("mouse_unhover", hide_label)


func show_label():
	self.visible = true


func hide_label():
	self.visible = false
