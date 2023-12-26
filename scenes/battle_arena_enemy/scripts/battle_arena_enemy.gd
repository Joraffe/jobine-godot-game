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
	BattleRadio.connect(BattleRadio.ENTITY_DAMAGED_BY_EFFECT, _on_entity_damaged_by_effect)
	BattleRadio.connect(BattleRadio.ADD_ELEMENTS_TO_ENTITY_BY_EFFECT, _on_add_elements_to_entity_by_effect)
	BattleRadio.connect(BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY, _on_elements_removed_from_entity)
	BattleRadio.connect(BattleRadio.STATUS_EFFECT_ADDED_BY_EFFECT, _on_status_effect_added_by_effect)
	BattleRadio.connect(BattleRadio.ENEMY_ATTACK_ANIMATION_QUEUED, _on_enemy_attack_animation_queued)
	BattleRadio.connect(BattleRadio.ENEMY_DEFEATED_ANIMATION_QUEUED, _on_enemy_defeated_animation_queued)


#=======================
# Setters
#=======================
func set_enemy(new_enemy : Enemy) -> void:
	enemy = new_enemy

	var instance_ids : Array[int] = [self.enemy.get_instance_id()]
	self.set("identifier", Identifier.new(instance_ids))

	# Also update child nodes with the entity
	# Also set the image data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_enemy",  # scene
			self.enemy.machine_name,  # instance
			"{name}.png".format({"name": self.enemy.machine_name})  # filename
		)
	)
	$HealthBar.set("health_bar_type", self.get_health_bar_type())
	$HealthBar.set("entity", self.enemy)
	$Aura.set("entity", self.enemy)
	$ComboDisplay.set("entity", self.enemy)
	$StatusEffects.set("entity", self.enemy)

func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())
	$Aura.set("entity_image_height", self.image_data.get_img_height())
	$Aura/Area2D.set("aura_width", self.image_data.get_img_width())
	$HealthBar.set("entity_image_height", self.image_data.get_img_height())
	$StatusEffects.set("entity_image_height", self.image_data.get_img_height())
	$StatusEffects.set("entity_image_width", self.image_data.get_img_width())


#========================
# Signal Handlers
#========================
func _on_entity_damaged_by_effect(
	_effector_instance_id : int,
	entity_instance_id : int,
	damage : int
) -> void:
	if not self.identifier.is_applicable(entity_instance_id):
		return

	self.enemy.take_damage(damage)
	$HealthBar.set("current_hp", self.enemy.current_hp)
	if self.enemy.has_fainted():
		self.emit_effect_resolved(
			self.enemy.get_instance_id(),
			BattleConstants.DAMAGE_EFFECT,
			BattleConstants.FAINTED
		)
	else:
		self.emit_effect_resolved(
			self.enemy.get_instance_id(),
			BattleConstants.DAMAGE_EFFECT,
			BattleConstants.DAMAGED
		)

func _on_add_elements_to_entity_by_effect(
	_effector_instance_id : int,
	target_instance_id : int,
	element_name : String,
	num_elements : int
) -> void:
	if not self.identifier.is_applicable(target_instance_id):
		return

	var added_element_names : Array[String] = []
	for i in num_elements:
		added_element_names.append(element_name)	
	self.enemy.add_element_names(added_element_names)
	$Aura.set("element_names", self.enemy.current_element_names)

func _on_elements_removed_from_entity(
	instance_id : int,
	removed_element_indexes : Array[int]
) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.enemy.remove_elements_at_indexes(removed_element_indexes)
	$Aura.set("element_names", self.enemy.current_element_names)

func _on_status_effect_added_by_effect(
	_effector_instance_id : int,
	instance_id : int,
	status_effect_name : String,
	status_effect_duration : int
) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.enemy.add_status_effect(status_effect_name, status_effect_duration)
	self.emit_effect_resolved(
		self.enemy.get_instance_id(),
		BattleConstants.STATUS_EFFECT,
		BattleConstants.ADDED_STATUS
	)

func _on_enemy_attack_animation_queued(instance_id : int, attack : EnemyAttack):
	if not self.identifier.is_applicable(instance_id):
		return

	$AttackDisplay.set("enemy_attack", attack)
	$AttackDisplay.animate()
	$Area2D.animate(attack)  # This will emit ENEMY_ATTACK_ANIMATION_FINISHED when finished

func _on_enemy_defeated_animation_queued(instance_id : int) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	$Area2D.animate_enemy_defeated()

func _on_new_status_effect_added() -> void:
	$StatusEffects.set("entity_current_status_effects", self.enemy.current_status_effects)


#=======================
# Helpers
#=======================
func get_health_bar_type() -> String:
	if self.enemy.entity_type == BattleConstants.ENTITY_ENEMY:
		return "enemy"

	if self.enemy.entity_type == BattleConstants.ENTITY_BOSS:
		return "boss"

	return "unknown enemy.entity_type"

func emit_effect_resolved(
	instance_id : int,
	effect_type : String,
	effect_result : String
) -> void:
	BattleRadio.emit_signal(
		BattleRadio.EFFECT_RESOLVED,
		instance_id,
		{
			BattleConstants.EFFECT_TYPE : effect_type,
			BattleConstants.EFFECT_RESULT : effect_result
		}
	)
