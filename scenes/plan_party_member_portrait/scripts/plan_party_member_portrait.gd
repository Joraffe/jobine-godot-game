extends Node2D


var character_machine_name : String :
	set = set_character_machine_name

var role_name : String
var character_human_name : String

var image_data : ImageData :
	set = set_image_data


#=======================
# Setters
#=======================
func set_character_machine_name(new_character_machine_name : String) -> void:
	character_machine_name = new_character_machine_name

	self.set(
		"image_data",
		ImageData.new(
			"plan_party_member_portrait",
			self.character_machine_name,
			"{name}_party_member.png".format({"name" : self.character_machine_name})
		)
	)


func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

#=======================
# Helpers
#=======================
func update_portrait_label_text() -> void:
	$Sprite2D/Label.set_text("{name} - {role}".format({
		"name" : self.character_human_name,
		"role" : self.role_name
	}))
