extends Node2D


var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PLAN_STARTED, _on_plan_started)


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_plan_started(_seed_data : Dictionary) -> void:
	self.set(
		"image_data",
		ImageData.new("plan_background", "plan", "plan.png")
	)
