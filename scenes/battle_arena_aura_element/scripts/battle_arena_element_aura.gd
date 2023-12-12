extends Node2D


var element : Element:
	set = set_element
var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass


#=======================
# Setters
#=======================
func set_element(new_element : Element) -> void:
	element = new_element

	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_aura_element",
			element.machine_name,
			"element_aura.png"
		)
	)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())


