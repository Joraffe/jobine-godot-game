extends Node2D


var character_type : String
var character : Character:
	set = set_character

var image_data : ImageData:
	set = set_image_data

var party_instance_ids : Array[int]
var identifier : Identifier


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.ENTITY_DAMAGED_BY_EFFECT, _on_entity_damaged_by_effect)
	BattleRadio.connect(BattleRadio.ADD_ELEMENTS_TO_ENTITY_BY_EFFECT, _on_add_elements_to_entity_by_effect)
	BattleRadio.connect(BattleRadio.ELEMENTS_REMOVED_FROM_ENTITY, _on_elements_removed_from_entity)
	BattleRadio.connect(BattleRadio.STATUS_EFFECT_ADDED_BY_EFFECT, _on_status_effect_added_by_effect)
	BattleRadio.connect(BattleRadio.STATUS_EFFECT_REMOVED_BY_EFFECT, _on_status_effect_removed_by_effect)


#=======================
# Setters
#=======================
func set_character(new_character : Character) -> void:
	character = new_character
	var instance_ids : Array[int] = [self.character.get_instance_id()]
	self.set("identifier", Identifier.new(instance_ids))

	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_character", # scene
			self.character.machine_name,  # instance
			self.get_character_image_filepath()  # filename
		)
	)
	$HealthBar.set("health_bar_type", self.character_type)
	$DisplayStatusEffect.set("status_effect_type", self.character_type)
	$HealthBar.set("entity", self.character)
	$Aura.set("entity", self.character)
	$Aura.set("element_names", self.character.current_element_names)
	$Area2D.set("character", self.character)
	$ComboDisplay.set("entity", self.character)
	$StatusEffects.set("entity", self.character)
	$DisplayStatusEffect.set("entity", self.character)

func set_image_data(new_image_data : ImageData):
	image_data = new_image_data

	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())
	$Aura.set("entity_image_height", self.image_data.get_img_height())
	$Aura/Area2D.set("aura_width", self.image_data.get_img_width())
	$StatusEffects.set("entity_image_height", self.image_data.get_img_height())
	$StatusEffects.set("entity_image_width", self.image_data.get_img_width())
	$HealthBar.set("entity_image_height", self.image_data.get_img_height())


#=======================
# Signal Handlers
#=======================
func _on_entity_damaged_by_effect(
	_effector_instance_id : int,
	entity_instance_id : int,
	damage : int
) -> void:
	if not self.identifier.is_applicable(entity_instance_id):
		return

	self.character.take_damage(damage)
	$HealthBar.set("current_hp", self.character.current_hp)
	if self.character.has_fainted():
		self.emit_effect_resolved(
			self.character.get_instance_id(),
			BattleConstants.DAMAGE_EFFECT,
			BattleConstants.FAINTED
		)
	else:
		self.emit_effect_resolved(
			self.character.get_instance_id(),
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
	self.character.add_element_names(added_element_names)
	$Aura.set("element_names", self.character.current_element_names)

func _on_elements_removed_from_entity(
	instance_id : int,
	removed_element_indexes : Array[int]
) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.character.remove_elements_at_indexes(removed_element_indexes)
	$Aura.set("element_names", self.character.current_element_names)

func _on_status_effect_added_by_effect(
	_effector_instance_id : int,
	instance_id : int,
	status_effect_name : String,
	status_effect_duration : int
) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.character.add_status_effect(status_effect_name, status_effect_duration)
	self.emit_effect_resolved(
		self.character.get_instance_id(),
		BattleConstants.STATUS_EFFECT,
		BattleConstants.ADDED_STATUS
	)

func _on_status_effect_removed_by_effect(
	_effector_instance_id : int,
	instance_id : int,
	status_effect_name : String,
	duration_to_remove : int
) -> void:
	if not self.identifier.is_applicable(instance_id):
		return

	self.character.remove_duration_from_status_effect(status_effect_name, duration_to_remove)
	self.character.filter_zero_duration_status_effects()
	self.emit_effect_resolved(
		self.character.get_instance_id(),
		BattleConstants.REMOVE_STATUS_EFFECT,
		BattleConstants.REMOVED_STATUS
	)

#=======================
# Helpers
#=======================
func get_character_image_filepath() -> String:
	return "{name}_{type}.png".format({
		"name" : self.character.machine_name,
		"type": self.character_type
	})

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
