extends Node2D


var data : Dictionary  # passed in from SceneSwitcher


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass

func _ready() -> void:
	self.setup_background()


#=======================
# Signal Handlers
#=======================



#=======================
# Helpers
#=======================
func setup_background() -> void:
	$Background.set("background_name", "commune")
