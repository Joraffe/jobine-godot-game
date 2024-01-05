extends Node2D


var image_data : ImageData :
	set = set_image_data
var art_caption : String :
	set = set_art_caption


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	self.set("image_data", self.get_image_data())
	self.set("art_caption", "Battle!")


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

func set_art_caption(new_art_caption : String) -> void:
	art_caption = new_art_caption

	$Area2D/Sprite2D/Label.set_text(self.art_caption)


#=======================
# Helpers
#=======================
func get_image_data() -> ImageData:
	return ImageData.new("hub_battle", "container", "container.png")
