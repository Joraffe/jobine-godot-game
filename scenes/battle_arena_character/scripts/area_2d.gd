extends Area2D


@onready var battle_arena_character : Node2D = self.get_parent()

var character : Character :
	set = set_character


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_DEFEATED_ANIMATION_QUEUED, _on_entity_defeated_animation_queued)


#=======================
# Signal Handlers
#=======================
func set_character(new_character : Character) -> void:
	character = new_character

	if character.has_fainted():
		self.enable_grayscale()


#=======================
# Signal Handlers
#=======================
func _on_entity_defeated_animation_queued(instance_id : int) -> void:
	if not self.is_applicable(instance_id):
		return

	self.animate_fainted()


#=======================
# Helpers
#=======================
func is_applicable(instance_id : int) -> bool:
	return instance_id == self.battle_arena_character.character.get_instance_id()

func animate_fainted() -> void:
	self.enable_grayscale()
	var tween = self.create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(0.5, 0.5), 1)
	tween.tween_callback(self.emit_defeated_animation_finished)

func enable_grayscale() -> void:
	$Sprite2D.get_material().set_shader_parameter("grayscale", true)

func disable_grayscale() -> void:
	$Sprite2D.get_material().set_shader_parameter("grayscale", false)

func emit_defeated_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_DEFEATED_ANIMATION_FINISHED,
		self.battle_arena_character.character.get_instance_id()
	)
