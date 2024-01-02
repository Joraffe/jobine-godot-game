extends Node2D


var max_hp : int :
	set = set_max_hp

var image_data : ImageData :
	set = set_image_data


#=======================
# Setters
#=======================
func set_max_hp(new_max_hp : int) -> void:
	max_hp = new_max_hp

	self.set("image_data", self.get_health_image_data(self.max_hp))
	$Sprite2D/Label.set_text(self.get_health_text(self.max_hp))

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Helpers
#=======================
func get_health_text(health : int) -> String:
	if health == 0:
		return ""
	else:
		return "{health}".format({"health" : health})

func get_health_image_data(health : int) -> ImageData:
	if health == 0:
		return ImageData.new("plan_party_member_health", "unselected", "party_member_health_unselected.png")
	else:
		return ImageData.new("plan_party_member_health", "health", "party_member_health.png")
