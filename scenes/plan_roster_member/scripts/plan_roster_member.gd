extends Node2D


var character_name : String :
	set = set_character_name
var current_selecting_role : String :
	set = set_current_selecting_role

var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass


#=======================
# Setters
#=======================
func set_character_name(new_character_name : String) -> void:
	character_name = new_character_name

	$Area2D.set("character_name", self.character_name)
	$Sprite2D/Role.set("character_name", self.character_name)
	self.set(
		"image_data",
		ImageData.new(
			"plan_roster_member",
			self.character_name,
			"{name}_roster_member.png".format({"name" : self.character_name})
		)
	)

func set_current_selecting_role(new_current_selecting_role : String) -> void:
	current_selecting_role = new_current_selecting_role

	$Area2D.set("current_selecting_role", self.current_selecting_role)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
