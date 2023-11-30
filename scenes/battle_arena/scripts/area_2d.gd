extends Area2D


var is_card_selected : bool = false
var card_selected : BattleFieldCardData


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

	BattleRadio.emit_signal("card_targeting_enabled", card_selected)

func _on_mouse_exited() -> void:
	if not is_card_selected:
		return

	BattleRadio.emit_signal("card_targeting_disabled", card_selected)

func _on_card_selected(card_data : BattleFieldCardData) -> void:
	is_card_selected = true
	card_selected = card_data

func _on_card_deselected(card_data : BattleFieldCardData) -> void:
	is_card_selected = false
	if card_selected == card_data:
		card_selected = null
