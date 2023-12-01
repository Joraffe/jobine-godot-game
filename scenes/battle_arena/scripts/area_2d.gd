extends Area2D


var is_card_selected : bool = false


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect("card_selected", _on_card_selected)
	BattleRadio.connect("card_deselected", _on_card_deselected)


#========================
# Signal Handlers
#========================
func _on_mouse_entered() -> void:
	if not is_card_selected:
		return

	BattleRadio.emit_signal("card_targeting_enabled")

func _on_mouse_exited() -> void:
	if not is_card_selected:
		return

	BattleRadio.emit_signal("card_targeting_disabled")

func _on_card_selected(_card : Card) -> void:
	is_card_selected = true

func _on_card_deselected(_card : Card) -> void:
	is_card_selected = false
