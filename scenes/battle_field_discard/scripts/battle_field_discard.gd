extends Node2D

var data : BattleFieldDiscardData:
	set = set_battle_field_discard_data
var image_data : ImageData = ImageData.new(
	"battle_field_discard",
	"empty",
	"discard.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect("battle_started", _on_battle_started)

func _ready() -> void:
	pass # Replace with function body.


#=======================
# Setters
#=======================
func set_battle_field_discard_data(new_data : BattleFieldDiscardData) -> void:
	data = new_data


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	data = battle_data.discard_data
