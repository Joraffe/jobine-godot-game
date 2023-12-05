extends Node2D


var entity:
	set = set_entity
var max_hp : int:
	set = set_max_hp
var current_hp : int:
	set = set_current_hp
var image_data : ImageData:
	set =  set_image_data


#=======================
# Setters
#=======================
func set_entity(new_entity) -> void:
	entity = new_entity

	# Also set the image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_health_bar", # scene
			entity.entity_type,  # instance
			"{name}.png".format({"name": "health_bar"})  # filename
		)
	)
	self.set("max_hp", entity.max_hp)
	self.set("current_hp", entity.current_hp)
	update_health_bar()

func set_max_hp(new_max_hp : int) -> void:
	max_hp = new_max_hp

func set_current_hp(new_current_hp : int) -> void:
	current_hp = new_current_hp
	update_health_bar()

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Sprite2D.set_texture(image_data.get_img_texture())


#========================
# Health Bar Functionality
#========================
func update_health_bar() -> void:
	$Sprite2D/Line2D.fill_health_bar(
		max_hp,
		current_hp,
		image_data.get_img_width()
	)
	$Sprite2D/Label.update_health_bar_text(
		max_hp,
		current_hp
	)
