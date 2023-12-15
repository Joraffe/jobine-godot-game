extends Node2D


var enemy : Enemy:
	set = set_enemy
var image_data : ImageData:
	set = set_image_data

var attack_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_CURRENT_HP_UPDATED, _on_current_hp_updated)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_QUEUED, _on_enemy_attack_queued)

func _ready() -> void:
	$AttackEffectTimer.connect("timeout", _on_attack_animation_delay_finished)


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
func _on_current_hp_updated(instance_id : int, new_current_hp) -> void:
	if self.enemy.get_instance_id() != instance_id:
		return

	$HealthBar.set("current_hp", new_current_hp)

func _on_enemy_attack_queued(attacking_enemy : Enemy, attack : EnemyAttack):
	if attacking_enemy != self.enemy:
		return

	$Area2D.animate_attack(attack)
	$AttackDisplay.set("enemy_attack", attack)
	$AttackDisplay.animate()
	self.attack_queue.enqueue(attack)
	$AttackEffectTimer.start()


func _on_attack_animation_delay_finished() -> void:
	emit_attack_effects(self.attack_queue.dequeue())
	BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_FINISHED)


#=======================
# Enemy Functionality
#=======================
func emit_attack_effects(attack : EnemyAttack):
	emit_attack_element_applied(attack)

	if attack.deals_damage():
		emit_attack_damage(attack)

	# Implement other attack effects later!

func emit_attack_element_applied(attack : EnemyAttack):
	BattleRadio.emit_signal(
		BattleRadio.LEAD_ELEMENT_APPLIED,
		attack.element_name,
		attack.num_applied_element
	)

func emit_attack_damage(attack : EnemyAttack):
	BattleRadio.emit_signal(
		BattleRadio.LEAD_DAMAGED,
		attack.base_damage
	)
