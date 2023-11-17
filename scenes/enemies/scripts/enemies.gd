extends Node2D


var enemies_data : EnemiesData:
	set = set_enemies_data
var image_data : ImageData = ImageData.new("enemies", "empty", "enemies.png")

#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)


#=======================
# Setters
#=======================
func set_enemies_data(new_enemies_data : EnemiesData) -> void:
	enemies_data = new_enemies_data
	
	$Area2D.render_enemies()


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	enemies_data = battle_data.enemies_data
