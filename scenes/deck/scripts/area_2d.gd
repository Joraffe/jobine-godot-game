extends Area2D


@onready var deck = get_parent()


var is_mouse_over_deck : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$"Sprite2D".set_texture(deck.image_data.get_img_texture())


func _on_mouse_entered():
	is_mouse_over_deck = true


func _on_mouse_exited():
	is_mouse_over_deck = false


func _input(event):
	if not (event is InputEventMouseButton):
		return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	if not is_mouse_over_deck:
		return

	if not deck.deck_data.has_cards():
		return
		
	if not deck.deck_data.can_draw_cards:
		return

	var card_data = deck.deck_data.draw_card()
	BattleRadio.emit_signal("draw_card", card_data)
