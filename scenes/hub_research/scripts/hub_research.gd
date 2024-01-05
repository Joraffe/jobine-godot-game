extends Node2D


var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass

func _ready() -> void:
	self.set("image_data", self.get_image_data())


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Helpers
#=======================
func get_image_data() -> ImageData:
	return ImageData.new("hub_research", "container", "container.png")
