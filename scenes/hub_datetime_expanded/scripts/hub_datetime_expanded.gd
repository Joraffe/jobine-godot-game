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
	self.position_calendar()
	self.position_period()


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
	return ImageData.new("hub_datetime_expanded", "container", "container.png")

func position_calendar() -> void:
	var container_width : int = self.image_data.get_img_width()
	var starting_x : int = (-1) * int(container_width / 2.0)
	var calendar_width : int = int(container_width / 2.0)
	$Calendar.position.x = starting_x + int(calendar_width / 2.0)

func position_period() -> void:
	var container_width : int = self.image_data.get_img_width()
	var starting_x : int = (-1) * int(container_width / 2.0)
	var period_width : int = int(container_width / 2.0)
	$Period.position.x = starting_x + period_width + int(period_width / 2.0)
