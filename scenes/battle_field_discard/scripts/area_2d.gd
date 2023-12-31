extends Area2D


@onready var battle_field_discard = get_parent()
var is_mouse_over_discard : bool = false


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$"Sprite2D".set_texture(battle_field_discard.image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_mouse_entered():
	is_mouse_over_discard = true


func _on_mouse_exited():
	is_mouse_over_discard = false
