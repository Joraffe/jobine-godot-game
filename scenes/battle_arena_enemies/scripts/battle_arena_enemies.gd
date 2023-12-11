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
	BattleRadio.connect(BattleRadio.COMBO_APPLIED, _on_combo_applied)
	BattleRadio.connect(BattleRadio.COMBO_BONUS_APPLIED, _on_combo_bonus_applied)

#=======================
# Setters
#=======================
func set_enemies(new_enemies : Array[Enemy]) -> void:
	enemies = new_enemies

	$Area2D.render_enemies()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	enemies = battle_data.enemies

func _on_card_played(card : Card, targeting : Targeting) -> void:
	if targeting.is_single_targeting():
		var enemy_name : String = targeting.primary_target_name
		var target_enemy : Enemy = self.get_enemy_by_name(enemy_name)
		self.handle_card_played_on_enemy(card, target_enemy)
		return

	if targeting.is_blast_targeting():
		var enemy_name : String = targeting.primary_target_name
		var primary_enemy : Enemy = self.get_enemy_by_name(enemy_name)
		var blast_enemies : Array[Enemy] = self.get_blast_enemies(primary_enemy)
		for enemy in blast_enemies:
			self.handle_card_played_on_enemy(card, enemy)
		return

	if targeting.is_all_targeting():
		for enemy in self.enemies:
			self.handle_card_played_on_enemy(card, enemy)

func _on_combo_applied(combo_data : Dictionary) -> void:
	var combo : Combo = combo_data[Combo.COMBO]
	var targeting : Targeting = Targeting.by_machine_name(
		combo.targeting_name,
		combo_data[Combo.ENTITY].machine_name
	)

	if targeting.is_single_targeting():
		self.handle_combo_single_targeting(combo_data)
		return

	if targeting.is_blast_targeting():
		self.handle_combo_blast_targeting(combo_data)
		return

	if targeting.is_all_targeting():
		self.handle_combo_all_targeting(combo_data)
		return

func _on_combo_bonus_applied(combo_bonus_data : Dictionary) -> void:
	var combo_bonus : ComboBonus = combo_bonus_data[ComboBonus.COMBO_BONUS]
	if not (combo_bonus.is_extra_damage() or combo_bonus.is_extra_status()):
		return

	var targeting = combo_bonus_data[ComboBonus.TARGETING]
	if targeting.is_single_targeting():
		var enemy_name : String = targeting.primary_target_name
		var target_enemy : Enemy = self.get_enemy_by_name(enemy_name)
		self.apply_combo_bonus_to_enemy(combo_bonus, target_enemy)
		return

	if targeting.is_blast_targeting():
		var enemy_name : String = targeting.primary_target_name
		var primary_enemy : Enemy = self.get_enemy_by_name(enemy_name)
		var blast_enemies : Array[Enemy] = self.get_blast_enemies(primary_enemy)
		for enemy in blast_enemies:
			self.apply_combo_bonus_to_enemy(combo_bonus, enemy)
		return

	if targeting.is_all_targeting():
		for enemy in self.enemies:
			self.apply_combo_bonus_to_enemy(combo_bonus, enemy)
		return


#======================
# Handler Helpers
#======================
func handle_card_played_on_enemy(card : Card, enemy : Enemy) -> void:
	if card.base_damage != 0:
		BattleRadio.emit_signal(
			BattleRadio.ENEMY_DAMAGED,
			enemy,
			card.base_damage
		)

	if card.element_amount != 0:
		BattleRadio.emit_signal(
			BattleRadio.ENEMY_ELEMENT_APPLIED,
			enemy,
			card.element_name,
			card.element_amount
		)

func handle_combo_single_targeting(combo_data : Dictionary) -> void:
	var combo: Combo = combo_data[Combo.COMBO]
	var target : Enemy = combo_data[Combo.ENTITY]
	self.apply_combo_to_enemy(combo, target)

func handle_combo_blast_targeting(combo_data : Dictionary) -> void:
	var combo: Combo = combo_data[Combo.COMBO]
	var target : Enemy = combo_data[Combo.ENTITY]
	var blast_targets = self.get_blast_enemies(target)
	for blast_target in blast_targets:
		self.apply_combo_to_enemy(combo, blast_target)

func handle_combo_all_targeting(combo_data : Dictionary) -> void:
	var combo : Combo = combo_data[Combo.COMBO]
	for enemy in enemies:
		self.apply_combo_to_enemy(combo, enemy)

func apply_combo_to_enemy(combo : Combo, enemy : Enemy) -> void:
	self.apply_combo_damage_to_enemy(combo, enemy)
	self.apply_combo_elements_to_enemy(combo, enemy)

func apply_combo_damage_to_enemy(combo : Combo, enemy : Enemy) -> void:
	if combo.base_damage != 0:
		BattleRadio.emit_signal(
			BattleRadio.ENEMY_DAMAGED,
			enemy,
			combo.base_damage
		)

func apply_combo_elements_to_enemy(combo : Combo, enemy : Enemy) -> void:
	if combo.applied_element_name != "":
		BattleRadio.emit_signal(
			BattleRadio.ENEMY_ELEMENT_APPLIED,
			enemy,
			combo.applied_element_name,
			combo.num_applied_element
		)


func handle_combo_bonus_single_targeting(combo_bonus : ComboBonus, target : Enemy) -> void:
	self.apply_combo_bonus_to_enemy(combo_bonus, target)

func handle_combo_bonus_blast_targeting(combo_bonus : ComboBonus, target) -> void:
	var blast_targets = self.get_blast_enemies(target)
	for blast_target in blast_targets:
		self.apply_combo_bonus_to_enemy(combo_bonus, blast_target)

func handle_combo_bonus_all_targeting(combo_bonus_data : Dictionary) -> void:
	var combo_bonus : ComboBonus = combo_bonus_data[ComboBonus.COMBO_BONUS]
	for enemy in self.enemies:
		self.apply_combo_bonus_to_enemy(combo_bonus, enemy)

func apply_combo_bonus_to_enemy(combo_bonus : ComboBonus, enemy : Enemy) -> void:
	if combo_bonus.is_extra_damage():
		apply_combo_bonus_damage_to_enemy(combo_bonus, enemy)
		return

	if combo_bonus.is_extra_status():
		apply_combo_bonus_status_to_enemy(combo_bonus, enemy)
		return

func apply_combo_bonus_damage_to_enemy(combo_bonus : ComboBonus, enemy : Enemy) -> void:
	BattleRadio.emit_signal(
		BattleRadio.ENEMY_DAMAGED,
		enemy,
		combo_bonus.damage
	)

func apply_combo_bonus_status_to_enemy(_combo_bonus : ComboBonus, _enemy : Enemy) -> void:
	# TODO: Apply status effect
	pass


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

func get_enemy_by_name(enemy_name : String) -> Enemy:
	var named_enemy : Enemy

	for enemy in self.enemies:
		if enemy.machine_name == enemy_name:
			named_enemy = enemy
			break

	return named_enemy
