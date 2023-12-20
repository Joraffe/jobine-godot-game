extends Node2D


var enemy : Enemy:
	set = set_enemy
var image_data : ImageData:
	set = set_image_data
var is_attacking : bool

var identifier : Identifier
var attack_queue : Queue = Queue.new()
var attack_effects_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_DAMAGED, _on_entity_damaged)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_ANIMATION_QUEUED, _on_enemy_attack_animation_queued)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_EFFECT_QUEUED, _on_enemy_attack_effect_queued)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_EFFECT_RESOLVED, _on_enemy_attack_effect_resolved)


#=======================
# Setters
#=======================
func set_enemy(new_enemy : Enemy) -> void:
	enemy = new_enemy
	var instance_ids : Array[int] = [self.enemy.get_instance_id()]
	self.set("identifier", Identifier.new(instance_ids))

	# Also update child nodes with the entity
	$HealthBar.set("health_bar_type", self.get_health_bar_type())
	$HealthBar.set("entity", enemy)
	$Aura.set("entity", enemy)
	$ComboDisplay.set("entity", enemy)
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

	# Also child related image data
	$Area2D/Sprite2D.set_texture(image_data.get_img_texture())
	$HealthBar.set("entity_image_height", self.image_data.get_img_height())
	$Aura.set("entity_image_height", self.image_data.get_img_height())
	$Aura/Area2D.set("aura_width", self.image_data.get_img_width())


#========================
# Signal Handlers
#========================
func _on_entity_damaged(instance_id : int, damage : int) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.enemy.take_damage(damage)
	$HealthBar.set("current_hp", self.enemy.current_hp)
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_HP_UPDATED,
		self.enemy.get_instance_id(),
		self.enemy.current_hp
	)

func _on_enemy_attack_animation_queued(instance_id : int, attack : EnemyAttack):
	if not self.identifier.is_applicable(instance_id):
		return

	$AttackDisplay.set("enemy_attack", attack)
	$AttackDisplay.animate()
	$Area2D.animate(attack)  # This will emit ENEMY_ATTACK_ANIMATION_FINISHED when finished

func _on_enemy_attack_effect_queued(instance_id : int, attack_effect_data : Dictionary) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	print('_on_enemy_attack_effect_queued called')
	var attack_effect_type : String = attack_effect_data["type"]
	
	if attack_effect_type == EnemyAttack.DAMAGE_TYPE:
		self.emit_lead_damaged_by_enemy(attack_effect_data)
		return

	if attack_effect_type == EnemyAttack.STATUS_TYPE:
		self.emit_status_attack_effect(attack_effect_data)
		return

	if attack_effect_type == EnemyAttack.STATUS_CARD_TYPE:
		self.emit_status_card_attack_effect(attack_effect_data)
		return

	# we resolve element application last because there's
	# the possibility of combos happening, which have their
	# own effects to be applied; would rather not have to
	# juggle both these attack_effects + the combo effects
	if attack_effect_type == EnemyAttack.ELEMENT_TYPE:
		self.emit_element_attack_effect(attack_effect_data)
		return

func _on_enemy_attack_effect_resolved(instance_id : int, resolve_data : Dictionary) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	# potential attack effect resolutions
	var type : String = resolve_data["type"]
	var result : String = resolve_data["result"]
	var finish_data : Dictionary = {}

	if type == EnemyAttack.DAMAGE_TYPE and result == EnemyAttack.FAINTED:
		finish_data["should_bail"] = true
		BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_EFFECT_FINISHED, finish_data)
		return

	if type == EnemyAttack.DAMAGE_TYPE and result == EnemyAttack.DAMAGED:
		BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_EFFECT_FINISHED, finish_data)
		return
 
	if type == EnemyAttack.ELEMENT_TYPE:
		# for tomorrow: have BattleStats.party._on_element_applied_to_entity
		# emit the ENEMY_ATTACK_EFFECT_RESOLVED signal to continue the sequence of
		# events here!
		BattleRadio.emit_signal(BattleRadio.ENEMY_ATTACK_EFFECT_FINISHED, finish_data)
		return


#=======================
# Helpers
#=======================
func get_health_bar_type() -> String:
	if self.enemy.entity_type == BattleConstants.ENTITY_ENEMY:
		return "enemy"

	if self.enemy.entity_type == BattleConstants.ENTITY_BOSS:
		return "boss"

	return "unknown enemy.entity_type"

func emit_lead_damaged_by_enemy(attack_effect_data : Dictionary) -> void:
	print('emit_lead_damaged_by_enemy called')
	BattleRadio.emit_signal(
		BattleRadio.LEAD_DAMAGED_BY_ENEMY,
		self.enemy.get_instance_id(),
		attack_effect_data["amount"]
	)

func emit_status_attack_effect(_attack_effect_data : Dictionary) -> void:
	pass

func emit_status_card_attack_effect(_attack_effect_data : Dictionary) -> void:
	pass

func emit_element_attack_effect(attack_effect_data : Dictionary) -> void:
	print('emit_element_attack_effect called')
	BattleRadio.emit_signal(
		BattleRadio.ELEMENTS_ADDED_TO_LEAD_BY_ENEMY,
		attack_effect_data["name"],
		attack_effect_data["amount"]
	)
