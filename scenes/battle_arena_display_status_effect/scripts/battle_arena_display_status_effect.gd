extends Node2D


var entity : Variant :
	set = set_entity

var entity_image_height : int

var status_effect_name : String :
	set = set_status_effect_name

var status_effect_type : String

var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.END_TURN_ANIMATION_QUEUED, _on_end_turn_animation_queued)


#=======================
# Setters
#=======================
func set_entity(new_entity : Variant) -> void:
	entity = new_entity

	self.entity.connect(BattleConstants.NEW_STATUS_EFFECT_DISPLAYED, _on_new_status_effect_displayed)

	var displayable_status_effect = self.entity.get_displayable_status_effect()
	if displayable_status_effect:
		self.show_status_effect(displayable_status_effect.machine_name)

func set_status_effect_name(new_status_effect_name : String) -> void:
	status_effect_name = new_status_effect_name

	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_display_status_effect",
			self.status_effect_name,
			"{name}_{type}.png".format({
				"name": self.status_effect_name,
				"type": self.status_effect_type
			})
		)
	)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_end_turn_animation_queued(instance_id : int, animation_name : String) -> void:
	if not self.is_applicable(instance_id):
		return

	if animation_name == StatusEffect.DEFROST_ANIMATION:
		self.tween_end_turn_defrost_animation()


func _on_new_status_effect_displayed(new_status_effect : StatusEffect) -> void:
	print('_on_new_status_effect_displayed ', new_status_effect)
	self.set("status_effect_name", new_status_effect.machine_name)
	self.tween_fade_in()


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id == self.entity.get_instance_id()

func show_status_effect(status_effect_to_show : String) -> void:
	self.set("status_effect_name", status_effect_to_show)
	$Sprite2D.modulate.a = 1

func tween_fade_in() -> void:
	var tween = self.create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 1, 0.1)

func tween_end_turn_defrost_animation() -> void:
	var tween = self.create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, 1)
	tween.tween_callback(self.emit_end_turn_animation_finished)

func emit_end_turn_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.END_TURN_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)
