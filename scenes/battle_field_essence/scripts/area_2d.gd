extends Area2D


@onready var battle_field_essence = get_parent()


var is_mouse_over_essence : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$"Sprite2D".set_texture(battle_field_essence.image_data.get_img_texture())


func _on_mouse_entered():
	is_mouse_over_essence = true


func _on_mouse_exited():
	is_mouse_over_essence = false
