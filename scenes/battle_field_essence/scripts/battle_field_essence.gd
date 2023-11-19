extends Node2D

var data : BattleFieldEssenceData:
	set = set_battle_field_essence_data
var image_data : ImageData = ImageData.new(
	"battle_field_essence",
	"empty",
	"essence.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("start_battle", _on_start_battle)

func _ready() -> void:
	pass # Replace with function body.


#=======================
# Setters
#=======================
func set_battle_field_essence_data(new_data : BattleFieldEssenceData) -> void:
	data = new_data


#========================
# Signal Handlers
#========================
func _on_start_battle(battle_data : BattleData) -> void:
	data = battle_data.essence_data
