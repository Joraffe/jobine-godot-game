extends Node2D


var enemy : Enemy:
	set = set_enemy
var current_attack : EnemyAttack :
	set = set_current_attack
var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_DAMAGED, _on_damaged)
	BattleRadio.connect(BattleRadio.ELEMENT_APPLIED_TO_ENTITY, _on_element_applied)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_QUEUED, _on_enemy_attack_queued)


#=======================
# Setters
#=======================
func set_enemy(new_enemy : Enemy) -> void:
	enemy = new_enemy

	# Also set the image data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_enemy",  # scene
			enemy.machine_name,  # instance
			"{name}.png".format({"name": enemy.machine_name})  # filename
		)
	)

func set_current_attack(new_attack : EnemyAttack) -> void:
	current_attack = new_attack
	$AttackDisplay.set("enemy_attack", self.current_attack)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	# Also update the Sprite2D with this new image data
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())

	$Aura.set("aura_width", image_data.get_img_width())
	# Also update child nodes with the enetity
	$HealthBar.set("entity", enemy)
	$Aura.set("entity", enemy)
	$ComboDisplay.set("entity", enemy)


#========================
# Signal Handlers
#========================
func _on_damaged(instance_id : int, damage : int) -> void:
	if self.enemy.get_instance_id() != instance_id:
		return

	$HealthBar.take_damage(damage)

func _on_element_applied(
	instance_id : int,
	applied_element_name : String,
	num_applied_element : int
) -> void:
	if self.enemy.get_instance_id() != instance_id:
		return

	for i in range(num_applied_element):
		$Aura.apply_element(Element.by_machine_name(applied_element_name))

func _on_enemy_attack_queued(attacking_enemy : Enemy, attack : EnemyAttack):
	if attacking_enemy != self.enemy:
		return

	current_attack = attack
	$Area2D.animate_attack(attack, emit_attack_effects)
	$AttackDisplay.show_then_hide_after_delay()


#=======================
# Enemy Functionality
#=======================
func emit_attack_effects():
	BattleRadio.emit_signal(
		BattleRadio.LEAD_ELEMENT_APPLIED,
		self.current_attack.element_name,
		self.current_attack.num_applied_element
	)

	if self.current_attack.deals_damage():
		BattleRadio.emit_signal(
			BattleRadio.LEAD_DAMAGED,
			self.current_attack.base_damage
		)

	# Implement other attack effects later!
