extends Node2D


var art_caption : String :
	set = set_art_caption

var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass

func _ready() -> void:
	self.set("image_data", self.get_image_data())
	self.set("art_caption", "Commune")


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
	return ImageData.new("hub_commune", "container", "container.png")
