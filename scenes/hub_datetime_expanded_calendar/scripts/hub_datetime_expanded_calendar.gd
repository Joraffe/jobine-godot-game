extends Node2D


var current_day : int :
	set = set_current_day


var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	HubRadio.connect(HubRadio.HUB_STARTED, _on_hub_started)

func _ready() -> void:
	self.set("image_data", self.get_default_image_data())


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

func set_current_day(new_current_day : int) -> void:
	current_day = new_current_day

	$Sprite2D/Label.set_text("{day}".format({"day" : self.current_day}))


#=======================
# Signal Handlers
#=======================
func _on_hub_started(hub_data : Dictionary) -> void:
	self.set("current_day", hub_data["current_day"])


#=======================
# Helpers
#=======================
func get_default_image_data() -> ImageData:
	return ImageData.new("hub_datetime_expanded_calendar", "calendar", "calendar.png")
