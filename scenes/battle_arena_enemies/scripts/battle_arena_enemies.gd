extends Node2D


var enemies : Array[Enemy]:
	set = set_enemies
var image_data : ImageData = ImageData.new(
	"battle_arena_enemies",
	"empty",
	"enemies.png"
)

#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)

#=======================
# Setters
#=======================
func set_enemies(new_enemies : Array[Enemy]) -> void:
	enemies = new_enemies

	$Combiner.set("entities", self.enemies)
	$Area2D.render_enemies()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	enemies = battle_data.enemies

func _on_card_played(card : Card, targeting : Targeting) -> void:
	if targeting.is_single_targeting():
		var enemy_instance_id : int = targeting.primary_target_instance_id
		var target_enemy : Enemy = self.get_enemy_by_instance_id(enemy_instance_id)
		self.handle_card_played_on_enemy(card, target_enemy)
		return

	if targeting.is_blast_targeting():
		var enemy_instance_id : int = targeting.primary_target_instance_id
		var primary_enemy : Enemy = self.get_enemy_by_instance_id(enemy_instance_id)
		var blast_enemies : Array[Enemy] = self.get_blast_enemies(primary_enemy)
		for enemy in blast_enemies:
			self.handle_card_played_on_enemy(card, enemy)
		return

	if targeting.is_all_targeting():
		for enemy in self.enemies:
			self.handle_card_played_on_enemy(card, enemy)

#======================
# Handler Helpers
#======================
func handle_card_played_on_enemy(card : Card, enemy : Enemy) -> void:
	if card.base_damage != 0:
		BattleRadio.emit_signal(
			BattleRadio.ENTITY_DAMAGED,
			enemy.get_instance_id(),
			card.base_damage
		)

	if card.element_amount != 0:
		BattleRadio.emit_signal(
			BattleRadio.ELEMENT_APPLIED_TO_ENTITY,
			enemy.get_instance_id(),
			card.element_name,
			card.element_amount
		)


#======================
# Enemy Helpers
#======================
func get_blast_enemies(target : Enemy) -> Array[Enemy]:
	var blast_enemies : Array[Enemy] = []

	var target_i : int
	var left_i : int
	var right_i : int
	for i in enemies.size():
		if enemies[i] == target:
			target_i = i
			left_i = i - 1
			right_i = i + 1

	blast_enemies.append(self.enemies[target_i])
	if left_i >= 0:
		blast_enemies.append(self.enemies[left_i])
	if right_i <= self.enemies.size() - 1:
		blast_enemies.append(self.enemies[right_i])

	return blast_enemies

func is_instance_id_applicable(instance_id : int) -> bool:
	for enemy in self.enemies:
		if enemy.get_instance_id() == instance_id:
			return true

	return false

func get_enemy_by_instance_id(instance_id : int) -> Enemy:
	var found_enemy : Enemy

	for enemy in self.enemies:
		if enemy.get_instance_id() == instance_id:
			found_enemy = enemy
			break

	return found_enemy

