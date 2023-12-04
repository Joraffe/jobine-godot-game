extends Resource
class_name BattleFieldEnergyData


var max_energy : int
var current_energy : int


func _init(energy_data : Dictionary) -> void:
	max_energy = energy_data[MAX_ENERGY]
	current_energy = energy_data[CURRENT_ENERGY]


const MAX_ENERGY : String = "max_energy"
const CURRENT_ENERGY : String = "current_energy"

const SOME_ENERGY : String = "some_energy"
const NO_ENERGY : String = "no_energy"
