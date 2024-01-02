extends Node2D


var element_name : String :
	set = set_element_name

var image_data : ImageData :
	set = set_image_data


#=======================
# Setters
#=======================
func set_element_name(new_element_name : String) -> void:
	element_name = new_element_name

	self.set(
		"image_data",
		ImageData.new(
			"plan_party_member_element",
			self.element_name,
			"party_member_element_{name}.png".format({"name" : self.element_name})
		)
	)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())
