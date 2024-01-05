extends Node2D


var current_time_period : String :
	set = set_current_time_period


var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	HubRadio.connect(HubRadio.HUB_STARTED, _on_hub_started)


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

func set_current_time_period(new_current_time_period : String) -> void:
	current_time_period = new_current_time_period

	self.set("image_data", self.get_time_period_image_data(self.current_time_period))
	$Sprite2D/Label.set_text("{period}".format({"period" : self.current_time_period.capitalize()}))


#=======================
# Signal Handlers
#=======================
func _on_hub_started(hub_data : Dictionary) -> void:
	self.set("current_time_period", hub_data["current_time_period"])


#=======================
# Helpers
#=======================
func get_time_period_image_data(time_period : String) -> ImageData:
	return ImageData.new(
		"hub_datetime_expanded_period",
		"time_period",
		"{period}.png".format({"period" : time_period})
	)
