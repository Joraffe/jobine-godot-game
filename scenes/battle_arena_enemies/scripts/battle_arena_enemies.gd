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
	BattleRadio.connect(BattleRadio.COMBO_APPLIED, _on_combo_applied)

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


func _on_combo_applied(combo_data : Dictionary) -> void:
	var combo : Combo = combo_data[Combo.COMBO]
	var targeting : Targeting = Targeting.by_machine_name(combo.targeting_name)

	if targeting.machine_name == Targeting.SINGLE:
		handle_single_targeting(combo_data)
	elif targeting.machine_name == Targeting.BLAST:
		handle_blast_targeting(combo_data)
	elif targeting.machine_name == Targeting.ALL:
		handle_all_targeting(combo_data)
	else:
		return

func handle_single_targeting(combo_data : Dictionary) -> void:
	var combo: Combo = combo_data[Combo.COMBO]
	var target : Enemy = combo_data[Combo.ENTITY]
	for enemy in enemies:
		if enemy == target:
			apply_combo_to_enemy(combo, enemy)

func handle_blast_targeting(combo_data : Dictionary) -> void:
	var combo: Combo = combo_data[Combo.COMBO]
	var target : Enemy = combo_data[Combo.ENTITY]

	var target_i : int
	var left_i : int
	var right_i : int
	for i in enemies.size():
		if enemies[i] == target:
			target_i = i
			left_i = i - 1
			right_i = i + 1

	apply_combo_to_enemy(combo, enemies[target_i])
	if left_i >= 0:
		apply_combo_to_enemy(combo, enemies[left_i])
	if right_i <= enemies.size() - 1:
		apply_combo_to_enemy(combo, enemies[right_i])

func handle_all_targeting(combo_data : Dictionary) -> void:
	var combo : Combo = combo_data[Combo.COMBO]
	for enemy in enemies:
		apply_combo_to_enemy(combo, enemy)

func apply_combo_to_enemy(combo : Combo, enemy : Enemy) -> void:
	apply_combo_damage_to_enemy(combo, enemy)
	apply_combo_elements_to_enemy(combo, enemy)

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
