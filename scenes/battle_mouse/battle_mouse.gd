extends Node


var default_mouse_image = preload("res://scenes/battle_mouse/resources/images/mouse.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(default_mouse_image)
