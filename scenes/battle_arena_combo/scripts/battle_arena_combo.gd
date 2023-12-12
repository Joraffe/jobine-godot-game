extends Node2D


var entity
var combo : Combo:
	set = set_combo
var original_label_position : Vector2


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.COMBO_APPLIED, _on_combo_applied)


#=======================
# Setters
#=======================
func set_combo(new_combo : Combo) -> void:
	combo = new_combo
	$Label.update_combo_text(combo)
	animate_combo_text()


#=======================
# Signal Handlers
#=======================
func _on_combo_applied(combo_data : Dictionary) -> void:
	if combo_data[Combo.ENTITY] != entity:
		return

	combo = combo_data[Combo.COMBO]


#=======================
# Combo Functionality
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
	tween.tween_callback(reset_combo_label)

func reset_combo_label() -> void:
	$Label.reset_combo_text()
	$Label.position = original_label_position
