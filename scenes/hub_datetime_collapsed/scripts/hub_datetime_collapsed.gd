extends Node2D

var datetime_data : Dictionary :
	set = set_datetime_data

var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	HubRadio.connect(HubRadio.HUB_STARTED, _on_hub_started)

func _ready() -> void:
	self.set("image_data", self.get_image_data())


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

func set_datetime_data(new_datetime_data : Dictionary) -> void:
	datetime_data = new_datetime_data

	$Sprite2D/Label.set_text(self.get_datetime_label_text(self.datetime_data))

#=======================
# Signal Handlers
#=======================
func _on_hub_started(hub_data : Dictionary) -> void:
	self.set("datetime_data", {
		HubConstants.DAY : hub_data["current_day"],
		HubConstants.PERIOD : hub_data["current_time_period"]
	})


#=======================
# Helpers
#=======================
func get_image_data() -> ImageData:
	return ImageData.new("hub_datetime_collapsed", "container", "container.png")

func get_datetime_label_text(provided_datetime_data : Dictionary) -> String:
	return "Day {day} - {period}".format({
		"day" : provided_datetime_data[HubConstants.DAY],
		"period" : provided_datetime_data[HubConstants.PERIOD].capitalize()
	})
