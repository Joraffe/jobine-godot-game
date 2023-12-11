extends Node2D


var enemy : Enemy:
	set = set_enemy
var enemy_image_data : ImageData:
	set = set_enemy_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENEMY_DAMAGED, _on_enemy_damaged)
	BattleRadio.connect(BattleRadio.ENEMY_ELEMENT_APPLIED, _on_enemy_element_applied)


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

	$Aura.set("aura_width", enemy_image_data.get_img_width())
	# Also update child nodes with the enetity
	$HealthBar.set("entity", enemy)
	$Aura.set("entity", enemy)
	$Combo.set("entity", enemy)


#========================
# Signal Handlers
#========================
func _on_enemy_damaged(damaged_enemy : Enemy, damage : int) -> void:
	if self.enemy != damaged_enemy:
		return

	$HealthBar.take_damage(damage)

func _on_enemy_element_applied(
	applied_enemy : Enemy,
	applied_element_name : String,
	num_applied_element : int
) -> void:
	if self.enemy != applied_enemy:
		return

	for i in range(num_applied_element):
		$Aura.apply_element(Element.by_machine_name(applied_element_name))


#=======================
# Enemy Functionality
#=======================
func play_card_on_enemy(card : Card, targeting : Targeting) -> void:
	if self.enemy.machine_name != targeting.primary_target_name:
		return

	var element_data : Dictionary = {
		Element.HUMAN_NAME : card.element_name.capitalize(),
		Element.MACHINE_NAME : card.element_name
	}

	var times_to_apply : int = card.element_amount
	for i in range(times_to_apply):
		$Aura.apply_element(Element.create(element_data))

	if card.base_damage != 0:
		$HealthBar.take_damage(card.base_damage)
