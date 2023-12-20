extends Resource
class_name Targeter


var current_targeting_name : String
var possible_target_instance_ids : Array[int]
var primary_target_instance_id : int



#=======================
# Godot Lifecycle Hooks
#=======================
func _init(
	targeting_name : String,
	target_instance_ids : Array[int],
	primary_instance_id : int,
) -> void:
	self.set("current_targeting_name", targeting_name)
	self.set("possible_target_instance_ids", target_instance_ids)
	self.set("primary_target_instance_id", primary_instance_id)


#=======================
# Internal Logic
#=======================
func is_single_targeting() -> bool:
	return self.current_targeting_name == Targeting.SINGLE

func is_splash_targeting() -> bool:
	return self.current_targeting_name == Targeting.SPLASH

func is_all_targeting() -> bool:
	return self.current_targeting_name == Targeting.ALL

func get_single_targeting_instance_ids() -> Array[int]:
	var target_instance_ids : Array[int] = []
	target_instance_ids.append(self.primary_target_instance_id)
	return target_instance_ids

func get_splash_targeting_instance_ids() -> Array[int]:	
	var splash_entity_ids : Array[int] = [self.primary_target_instance_id]

	var left_i : int
	var right_i : int
	for i in range(0, self.possible_target_instance_ids.size()):
		if self.possible_target_instance_ids[i] == self.primary_target_instance_id:
			left_i = i - 1
			right_i = i + 1

	var possible_indexes : Array[int] = []
	if left_i >= 0:
		possible_indexes.append(left_i)
	if right_i <= self.possible_target_instance_ids.size() - 1:
		possible_indexes.append(right_i)

	var rand_i = randi_range(0, possible_indexes.size() - 1)
	var splash_i = possible_indexes[rand_i]
	splash_entity_ids.append(self.possible_target_instance_ids[splash_i])

	return splash_entity_ids

func get_all_targeting_instance_ids() -> Array[int]:
	return self.possible_target_instance_ids


#=======================
# Public Interface
#=======================
func instance_ids() -> Array[int]:
	var target_instance_ids : Array[int]

	if self.is_single_targeting():
		target_instance_ids = self.get_single_targeting_instance_ids()
	elif self.is_splash_targeting():
		target_instance_ids = self.get_splash_targeting_instance_ids()
	elif self.is_all_targeting():
		target_instance_ids = self.get_all_targeting_instance_ids()

	return target_instance_ids
