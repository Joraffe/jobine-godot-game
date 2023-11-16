extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Area2D".connect("mouse_hover", show_panel_container)
	$"../../Area2D".connect("mouse_unhover", hide_panel_container)


func show_panel_container():
	self.visible = true


func hide_panel_container():
	self.visible = false
