extends Node2D

var data : BattleFieldEnergyData:
	set = set_battle_field_energy_data
var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.PLAYER_TURN_STARTED, _on_player_turn_started)

#=======================
# Setters
#=======================
func set_battle_field_energy_data(new_data : BattleFieldEnergyData) -> void:
	data = new_data

	# Also set the image_data
	var instance_name : String
	if data.current_energy > 0:
		instance_name = BattleFieldEnergyData.SOME_ENERGY
	elif data.current_energy == 0:
		instance_name = BattleFieldEnergyData.NO_ENERGY

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
	$Area2D.update_energy_label(data.current_energy, data.max_energy)


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	# This also involves setting up initial max_energy
	data = battle_data.energy_data


func _on_player_turn_started() -> void:
	var max_energy = data.max_energy

	# This effectively replenishes energy at the start of turn
	data = BattleFieldEnergyData.new({
		BattleFieldEnergyData.MAX_ENERGY: max_energy,
		BattleFieldEnergyData.CURRENT_ENERGY: 3
	})

	BattleRadio.emit_signal(BattleRadio.ENERGY_GAINED, data.current_energy)
