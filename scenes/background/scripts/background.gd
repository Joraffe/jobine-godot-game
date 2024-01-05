extends Node2D

var background_name : String :
	set =set_background_name

var image_data : ImageData :
	set = set_image_data


#=======================
# Setters
#=======================
func set_background_name(new_background_name : String) -> void:
	background_name = new_background_name

	self.set("image_data", self.get_image_data())
	self.align_to_viewport()

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Helpers
#=======================
func get_image_data() -> ImageData:
	return ImageData.new(
		"background",
		"background",
		"{name}.png".format({"name" : self.background_name})
	)

func align_to_viewport() -> void:
	var offset_x : float = ViewportConstants.SCREEN_WIDTH / 2.0
	var offset_y : float = ViewportConstants.SCREEN_HEIGHT / 2.0
	self.set_position(Vector2(offset_x, offset_y))
