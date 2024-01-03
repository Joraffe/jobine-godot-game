extends Node


var current_scene = null


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	var root = self.get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


#=======================
# Helpers
#=======================
func goto_scene(path : String, data : Dictionary) -> void:
	self.call_deferred("_deferred_goto_scene", path, data)


func _deferred_goto_scene(path : String, data : Dictionary) -> void:
	self.current_scene.free()

	var s = ResourceLoader.load(path)
	self.current_scene = s.instantiate()
	self.current_scene.set("data", data)

	self.get_tree().root.add_child(current_scene)
	self.get_tree().current_scene = current_scene
