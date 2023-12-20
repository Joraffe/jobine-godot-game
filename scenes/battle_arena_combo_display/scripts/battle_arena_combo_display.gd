extends Node2D


var entity : Variant
var combo : Combo :
	set = set_combo
var original_label_position : Vector2


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.COMBO_ANIMATION_QUEUED, _on_combo_animation_queued)


#=======================
# Setters
#=======================
func set_combo(new_combo : Combo) -> void:
	combo = new_combo
	$Label.update_combo_text(combo)
	self.animate_combo_text()


#=======================
# Signal Handlers
#=======================
func _on_combo_animation_queued(instance_id : int, combo_to_animate : Combo) -> void:
	if instance_id != self.entity.get_instance_id():
		return
	self.set("combo", combo_to_animate)


#=======================
# Helpers
#=======================
func animate_combo_text() -> void:
	var tween = create_tween()
	var label = $Label
	original_label_position = label.position
	tween.tween_property(
		label,
		"position",
		Vector2(label.position.x, label.position.y - 50),
		0.5
	)
	tween.tween_callback(self.reset_combo_label)
	tween.tween_callback(self.emit_combo_animation_finished)

func reset_combo_label() -> void:
	$Label.reset_combo_text()
	$Label.position = original_label_position

func emit_combo_animation_finished() -> void:
	BattleRadio.emit_signal(
		BattleRadio.COMBO_ANIMATION_FINISHED,
		self.entity.get_instance_id()
	)
