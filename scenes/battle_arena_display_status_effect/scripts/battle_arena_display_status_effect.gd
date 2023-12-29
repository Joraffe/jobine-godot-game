extends Node2D


var entity : Variant

var status_effect_name : String :
	set = set_status_effect_name

var image_data : ImageData :
	set = set_image_data


#=======================
# Setters
#=======================
func set_status_effect_name(new_status_effect_name : String) -> void:
	status_effect_name = new_status_effect_name

	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_display_status_effect",
			self.status_effect_name,
			"{name}.png".format({"name": self.status_effect_name})
		)
	)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())

func animate_status_effect(status_effect_to_animate : String) -> void:
	self.set("status_effect_name", status_effect_to_animate)
	self.tween_fade_in_and_out()

func tween_fade_in_and_out() -> void:
	var tween = self.create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 1, 0.1)
	tween.tween_property($Sprite2D, "modulate:a", 0, 1).set_delay(1)
	tween.tween_callback(self.emit_enemy_skip_turn_animation_finished)

func emit_enemy_skip_turn_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_SKIP_TURN_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)
