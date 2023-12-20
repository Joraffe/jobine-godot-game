extends Node2D


var lead_instance_id : int :
	set = set_lead_instance_id
var lead_character : Character :
	set = set_lead_character


var image_data : ImageData = ImageData.new(
	"battle_arena_party_lead",
	"empty",
	"party_lead.png"
)

var targeter : Targeter


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.LEAD_DAMAGED_BY_ENEMY, _on_lead_damaged_by_enemy)
	BattleRadio.connect(BattleRadio.ELEMENTS_ADDED_TO_LEAD_BY_ENEMY, _on_elements_added_to_lead_by_enemy)
	BattleRadio.connect(BattleRadio.NEXT_LEAD_STATS_RESPONDED, _on_next_lead_stats_responded)


#=======================
# Setters
#=======================
func set_lead_character(new_character : Character) -> void:
	print('party_lead.set_lead_instance_id called')
	lead_character = new_character
	self.set("lead_instance_id", self.lead_character.get_instance_id())
	$Area2D.empty_lead()
	$Area2D.render_lead()


func set_lead_instance_id(new_instance_id : int) -> void:
	print('party_lead.set_lead_instance_id called')
	lead_instance_id = new_instance_id
	
	var new_combiner_entity_ids : Array[int] = [self.lead_instance_id]
	$Combiner.set("entity_ids", new_combiner_entity_ids)
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_LEAD_UPDATED,
		self.lead_instance_id
	)


#========================
# Signal Handlers
#========================
func _on_lead_damaged_by_enemy(enemy_instance_id : int, damage : int) -> void:
	self.lead_character.take_damage(damage)
	self.emit_current_hp_updated()
	if self.lead_character.has_fainted():
		self.request_next_lead()
		self.emit_attack_effect_resolved(
			enemy_instance_id,
			EnemyAttack.DAMAGE_TYPE,
			"fainted"
		)
	else:
		self.emit_attack_effect_resolved(
			enemy_instance_id,
			EnemyAttack.DAMAGE_TYPE,
			"damaged"
		)

func _on_elements_added_to_lead_by_enemy(element_name : String, num_applied : int) -> void:
	print('_on_elements_added_to_lead_by_enemy')
	var elements_to_add : Array[String] = []
	for i in num_applied:
		elements_to_add.append(element_name)

	self.lead_character.add_element_names(elements_to_add)
	self.emit_current_element_names_updated()

func _on_next_lead_stats_responded(
	requester_instance_id : int,
	stats : Dictionary
) -> void:
	if not self.is_applicable_to_lead(requester_instance_id):
		return

	var swapped_character : Character
	var swap_position : String = stats["swap_position"]
	if swap_position == "swap_top_character":
		swapped_character = self.top_swap_character
	elif swap_position == "swap_bottom_character":
		swapped_character = self.bottom_swap_character

	BattleRadio.emit_signal(
		BattleRadio.CHARACTER_SWAPPED,
		swapped_character.get_instance_id(),
		swap_position
	)


#========================
# Helpers
#========================
func is_applicable_to_lead_character(instance_id : int) -> bool:
	return instance_id == self.lead_character.get_instance_id()

func is_applicable_to_lead(instance_id : int) -> bool:
	return instance_id == self.get_instance_id()

func emit_current_hp_updated() -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_HP_UPDATED,
		self.lead_instance_id,
		self.lead_character.current_hp
	)

func emit_current_element_names_updated() -> void:
	print('emit_current_element_names_updated called')
	BattleRadio.emit_signal(
		BattleRadio.ENTITY_CURRENT_ELEMENT_NAMES_UPDATED,
		self.lead_instance_id,
		self.lead_character.current_element_names
	)

func emit_attack_effect_resolved(
	enemy_instance_id : int,
	attack_effect_type : String,
	attack_effect_result : String
) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_ATTACK_EFFECT_RESOLVED,
		enemy_instance_id,
		{
			"type" : attack_effect_type,
			"result" : attack_effect_result
		}
	)

func request_next_lead() -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_LEAD_STATS_REQUESTED,
		self.get_instance_id()
	)
