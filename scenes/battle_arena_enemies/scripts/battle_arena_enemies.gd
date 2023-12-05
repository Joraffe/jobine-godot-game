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
