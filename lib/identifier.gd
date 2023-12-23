extends Resource
class_name Identifier


var instance_ids : Array[int]


func _init(_instance_ids : Array[int]) -> void:
	instance_ids = _instance_ids

func is_applicable(compared_instance_id : int) -> bool:
	return compared_instance_id in self.instance_ids
