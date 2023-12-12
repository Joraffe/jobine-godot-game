extends Resource
class_name Enemy


var human_name : String
var machine_name : String
var element_name : String
var max_hp : int
var current_hp : int
var entity_type : String


func _init(
	_human_name : String,
	_machine_name : String,
	_element_name : String,
	_max_hp : int,
	_current_hp : int,
	_entity_type : String
):
	human_name = _human_name
	machine_name = _machine_name
	element_name = _element_name
	max_hp = _max_hp
	current_hp = _current_hp
	entity_type = _entity_type

func as_dict() -> Dictionary:
	return {
		HUMAN_NAME : human_name,
		MACHINE_NAME : machine_name,
		ELEMENT_NAME : element_name,
		MAX_HP : max_hp,
		CURRENT_HP : current_hp,
		ENTITY_TYPE: entity_type
	}

static func create(enemy_data : Dictionary) -> Enemy:
	return Enemy.new(
		enemy_data[Enemy.HUMAN_NAME],
		enemy_data[Enemy.MACHINE_NAME],
		enemy_data[Enemy.ELEMENT_NAME],
		enemy_data[Enemy.MAX_HP],
		enemy_data[Enemy.CURRENT_HP],
		enemy_data[Enemy.ENTITY_TYPE]
	)

static func create_multi(enemies_data : Array[Dictionary]) -> Array[Enemy]:
	var enemies : Array[Enemy] = []

	for enemy_data in enemies_data:
		enemies.append(Enemy.create(enemy_data))
	
	return enemies



#========================
# Init Param kwarg names
#========================
const HUMAN_NAME : String = "human_name"
const MACHINE_NAME : String = "machine_name"
const ELEMENT_NAME : String = "element_name"
const MAX_HP : String = "max_hp"
const CURRENT_HP : String = "current_hp"
const ENTITY_TYPE : String = "entity_type"


#============================
# Enemy machine_name list
#============================
static func get_random_enemy_machine_name() -> String:
	var rng = RandomNumberGenerator.new()
	var rand_i = rng.randi_range(0, Enemy.ALL_ENEMIES.size() - 1)
	return Enemy.ALL_ENEMIES[rand_i]

static func slime_enemy_name_by_element(slime_element : String) -> String:
	match slime_element:
		Element.FIRE:
			return Enemy.FIRE_SLIME
		Element.WATER:
			return Enemy.WATER_SLIME
		Element.NATURE:
			return Enemy.NATURE_SLIME
		Element.VOLT:
			return Enemy.VOLT_SLIME
		Element.ICE:
			return Enemy.ICE_SLIME
		Element.AERO:
			return Enemy.AERO_SLIME
		_:
			return ""

const ALL_ENEMIES : Array[String] = [
	Enemy.FIRE_SLIME,
	Enemy.WATER_SLIME,
	Enemy.NATURE_SLIME,
	Enemy.VOLT_SLIME,
	Enemy.ICE_SLIME,
	Enemy.AERO_SLIME
]
const FIRE_SLIME : String = "fire_slime"
const WATER_SLIME : String = "water_slime"
const NATURE_SLIME : String = "nature_slime"
const VOLT_SLIME : String = "volt_slime"
const ICE_SLIME : String = "ice_slime"
const AERO_SLIME : String = "aero_slime"


#============================
# Other constants
#============================
const ENTITY_TYPE_ENEMY : String = "enemy"
const ENTITY_TYPE_BOSS : String = "boss"
