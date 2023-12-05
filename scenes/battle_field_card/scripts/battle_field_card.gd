extends Node2D


var card : Card:
	set = set_card
var available_energy : int:
	set = set_available_energy
var card_image_data : ImageData:
	set = set_card_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.CURRENT_ENERGY_UPDATED, _on_current_energy_updated)


#=======================
# Setters
#=======================
func set_card(new_card : Card) -> void:
	card = new_card
	# Also set the card_image_data
	self.set(
		"card_image_data",
		ImageData.new(
			"battle_field_card",  # scene
			self.card.machine_name,  # instance
			"{name}.png".format({"name": self.card.machine_name})  # filename
		)
	)

func set_available_energy(new_available_energy : int) -> void:
	available_energy = new_available_energy

	# Update the Card Cost Stlying as well
	var color : Color
	if can_play_card():
		color = Color.BLACK
	else:
		color = Color.DARK_RED
	$Area2D/Sprite2D/Panel.update_stylebox(color)
	$Area2D/Sprite2D/Panel/Label.update_label_styling(
		"{cost}".format({"cost": self.card.cost}),
		color
	)

func set_card_image_data(new_card_image_data : ImageData):
	card_image_data = new_card_image_data

	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(card_image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_current_energy_updated(current_energy : int) -> void:
	available_energy = current_energy


#========================
# Data Helpers
#========================
func can_play_card() -> bool:
	return self.available_energy >= self.card.cost
