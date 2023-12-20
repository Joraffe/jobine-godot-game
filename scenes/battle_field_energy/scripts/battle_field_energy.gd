extends Node2D


var max_energy : int:
	set = set_max_energy
var current_energy : int:
	set = set_current_energy
var image_data : ImageData:
	set = set_image_data

const SOME_ENERGY : String = "some_energy"
const NO_ENERGY : String = "no_energy"


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)

#=======================
# Setters
#=======================
func set_max_energy(new_max_energy : int) -> void:
	max_energy = new_max_energy

func set_current_energy(new_current_energy : int) -> void:
	current_energy = new_current_energy

	# Also set the image_data
	var instance_name : String
	if current_energy > 0:
		instance_name = SOME_ENERGY
	elif current_energy == 0:
		instance_name = NO_ENERGY

	self.set(
		"image_data",
		ImageData.new(
			"battle_field_energy", # scene
			instance_name,  # instance
			"{name}.png".format({"name": instance_name})  # filename
		)
	)


func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data
	# Also update the Sprite2D with this new image
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())
	$Area2D.update_energy_label(current_energy, max_energy)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	# This also involves setting up initial max_energy
	max_energy = battle_data.max_energy
	current_energy = battle_data.current_energy

func _on_player_turn_started() -> void:
	# This effectively replenishes energy at the start of turn
	current_energy = self.max_energy

	BattleRadio.emit_signal(
		BattleRadio.CURRENT_ENERGY_UPDATED,
		current_energy
	)

func _on_card_played(card : Card) -> void:
	current_energy = self.current_energy - card.cost

	BattleRadio.emit_signal(
		BattleRadio.CURRENT_ENERGY_UPDATED,
		current_energy
	)

func _on_combo_bonus_applied(
	_instance_id : int,
	combo_bonus : ComboBonus,
	_targeting : Targeting
) -> void:
	if not combo_bonus.is_extra_energy():
		return

	current_energy = self.current_energy + combo_bonus.energy_amount
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_ENERGY_UPDATED,
		current_energy
	)
