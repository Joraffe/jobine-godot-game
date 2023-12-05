extends Node2D


var enemy : Enemy:
	set = set_enemy
var enemy_image_data : ImageData:
	set = set_enemy_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)


#=======================
# Setters
#=======================
func set_enemy(new_enemy : Enemy) -> void:
	enemy = new_enemy

	# Also set the image data
	self.set(
		"enemy_image_data",
		ImageData.new(
			"battle_arena_enemy",  # scene
			enemy.machine_name,  # instance
			"{name}.png".format({"name": enemy.machine_name})  # filename
		)
	)

func set_enemy_image_data(new_enemy_image_data : ImageData) -> void:
	enemy_image_data = new_enemy_image_data

	# Also update the Sprite2D with this new image data
	$Area2D/Sprite2D.set_texture(enemy_image_data.get_img_texture())
	# Also update the Health Bar
	$HealthBar.set("entity", enemy)


#========================
# Signal Handlers
#========================
func _on_card_played(card : Card, targets: Array) -> void:
	if enemy not in targets:
		return

	var element_data : Dictionary = {
		Element.HUMAN_NAME : card.element_name.capitalize(),
		Element.MACHINE_NAME : card.element_name
	}
	var times_to_apply : int = card.effect_count
	for i in range(times_to_apply):
		$Aura.apply_element(Element.create(element_data))
