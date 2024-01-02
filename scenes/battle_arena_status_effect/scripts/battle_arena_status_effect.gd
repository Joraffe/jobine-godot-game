extends Node2D


var status_effect : StatusEffect :
	set = set_status_effect

var entity_image_width : int
var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass
	#BattleRadio.connect(BattleRadio.STATUS_EFFECT_DURATION_UPDATED, _on_status_effect_duration_updated)


#=======================
# Setters
#=======================
func set_status_effect(new_status_effect : StatusEffect) -> void:
	status_effect = new_status_effect

	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_status_effect",
			self.status_effect.machine_name,
			"{name}.png".format({"name" : self.status_effect.machine_name})
		)
	)
	self.update_duration_text(self.status_effect.duration)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_status_effect_duration_updated(status_effect_instance_id : int, new_duration : int) -> void:
	if not self.is_applicable(status_effect_instance_id):
		return

	self.status_effect.duration = new_duration
	self.update_duration_text(self.status_effect.duration)


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id == self.status_effect.get_instance_id()

func update_duration_text(duration : int) -> void:
	if self.status_effect.stackable:
		$Area2D/Sprite2D/Panel/MarginContainer/Label.text = "{duration}".format({
			"duration" : duration
		})
