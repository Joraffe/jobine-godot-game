extends Node2D


var card : Card :
	set = set_card
var available_energy : int :
	set = set_available_energy
var lead_character : Character :
	set = set_lead_character
var is_player_turn : bool :
	set = set_is_player_turn
var card_image_data : ImageData:
	set = set_card_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.CURRENT_LEAD_UPDATED, _on_current_lead_updated)
	BattleRadio.connect(BattleRadio.CURRENT_ENERGY_UPDATED, _on_current_energy_updated)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_ENDED, _on_player_turn_ended)

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
	$Area2D/Sprite2D/EffectPanel/MarginContainer/EffectLabel.update_effect_label_text(
		card.card_text()
	)
	$Area2D/Sprite2D/NamePanel/NameLabel.update_name_label_text(
		card.human_name
	)

func set_available_energy(new_available_energy : int) -> void:
	available_energy = new_available_energy

	# Update the Card Cost Stlying as well
	var color : Color
	if has_enough_energy():
		color = Color.BLACK
	else:
		color = Color.RED
	$Area2D/Sprite2D/CostPanel.update_stylebox(color)
	$Area2D/Sprite2D/CostPanel/CostLabel.update_label_styling(
		"{cost}".format({"cost": self.card.cost}),
		color
	)

func set_lead_character(new_lead_character : Character) -> void:
	lead_character = new_lead_character

func set_is_player_turn(new_is_player_turn : bool) -> void:
	is_player_turn = new_is_player_turn

func set_card_image_data(new_card_image_data : ImageData):
	card_image_data = new_card_image_data

	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(card_image_data.get_img_texture())


#========================
# Signal Handlers
#========================
func _on_current_lead_updated(updated_leader : Character) -> void:
	self.set("lead_character", updated_leader)

func _on_current_energy_updated(current_energy : int) -> void:
	self.set('available_energy', current_energy)

func _on_player_turn_started() -> void:
	self.set("is_player_turn", true)

func _on_player_turn_ended() -> void:
	self.set("is_player_turn" , false)


#========================
# Data Helpers
#========================
func has_enough_energy() -> bool:
	return self.available_energy >= self.card.cost

func belongs_to_lead() -> bool:
	return self.lead_character.machine_name == self.card.character_name

func can_play_card() -> bool:
	return self.has_enough_energy() and self.belongs_to_lead()
