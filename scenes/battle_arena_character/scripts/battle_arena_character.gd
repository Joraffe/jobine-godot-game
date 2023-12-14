extends Node2D


var character : Character:
	set = set_character

var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_CURRENT_HP_UPDATED, _on_current_hp_updated)


#=======================
# Setters
#=======================
func set_character(new_character : Character) -> void:
	character = new_character

	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_character", # scene
			self.character.machine_name,  # instance
			"{name}.png".format({"name": self.character.machine_name})  # filename
		)
	)
	$HealthBar.set("entity", self.character)
	$Aura.set("entity", self.character)
	$Combo.set("entity", self.character)

func set_image_data(new_image_data : ImageData):
	image_data = new_image_data
	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())
	$Aura.set("aura_width", self.image_data.get_img_width())


#=======================
# Signal Handlers
#=======================
func _on_current_hp_updated(instance_id : int, new_current_hp : int) -> void:
	if instance_id != self.character.get_instance_id():
		return

	$HealthBar.set("current_hp", new_current_hp)
