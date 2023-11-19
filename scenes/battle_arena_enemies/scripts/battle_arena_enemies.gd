extends Node2D


var data : BattleArenaEnemiesData:
	set = set_battle_arena_enemies_data
var image_data : ImageData = ImageData.new(
	"battle_arena_enemies",
	"empty",
	"enemies.png"
)

#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)


#=======================
# Setters
#=======================
func set_battle_arena_enemies_data(new_data : BattleArenaEnemiesData) -> void:
	data = new_data

	$Area2D.render_enemies()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	data = battle_data.enemies_data
