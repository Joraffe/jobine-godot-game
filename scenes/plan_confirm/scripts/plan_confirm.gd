extends Node2D


var container_image_data : ImageData :
	set = set_container_image_data



#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	self.set("container_image_data", ImageData.new("plan_confirm", "container", "container.png"))


#=======================
# Setters
#=======================
func set_container_image_data(new_container_image_data : ImageData) -> void:
	container_image_data = new_container_image_data

	$ContainerSprite2D.set_texture(self.container_image_data.get_img_texture())
