extends Area2D


@onready var battle_field_deck = get_parent()
var is_mouse_over_deck : bool = false


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	$"Sprite2D".set_texture(battle_field_deck.image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_mouse_entered():
	is_mouse_over_deck = true

func _on_mouse_exited():
	is_mouse_over_deck = false

func _input(event):
	if not battle_field_deck.is_player_turn:
		return

	if not is_mouse_over_deck:
		return

	if not (event is InputEventMouseButton):
		return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	if not battle_field_deck.has_cards():
		return

	if not battle_field_deck.can_draw:
		return

	# var card = battle_field_deck.deck.draw_card()
	# BattleRadio.emit_signal(BattleRadio.CARD_DRAWN, card)
