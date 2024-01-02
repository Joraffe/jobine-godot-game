extends Node2D


var character_human_name : String :
	set = set_character_human_name
var character_machine_name : String :
	set = set_character_machine_name
var character_max_hp : int :
	set = set_character_max_hp
var character_element_name : String :
	set = set_character_element_name
var character_combos : Array[String] :
	set = set_character_combos
var party_role : String :
	set = set_party_role

var container_image_data : ImageData :
	set = set_container_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass

func _ready() -> void:
	self.set("container_image_data", ImageData.new("plan_party_member", "container", "container.png"))
	self.position_portrait()
	self.position_element()
	self.position_health()
	self.position_combos()
	if self.character_machine_name != PlanConstants.UNSELECTED:
		$Portrait.update_portrait_label_text()


#=======================
# Setters
#=======================
func set_character_machine_name(new_character_machine_name : String) -> void:
	character_machine_name = new_character_machine_name

	$Portrait.set("character_machine_name", self.character_machine_name)

func set_character_human_name(new_character_human_name : String) -> void:
	character_human_name = new_character_human_name

	$Portrait.set("character_human_name", self.character_human_name)

func set_character_max_hp(new_character_max_hp : int) -> void:
	character_max_hp = new_character_max_hp

	$Health.set("max_hp", self.character_max_hp)

func set_character_element_name(new_character_element_name : String) -> void:
	character_element_name = new_character_element_name

	$Element.set("element_name", self.character_element_name)

func set_character_combos(new_character_combos : Array[String]) -> void:
	character_combos = new_character_combos

	$Combos.set("combos", self.character_combos)

func set_party_role(new_party_role : String) -> void:
	party_role = new_party_role

	$Portrait.set("role_name", self.get_portrait_role_name(self.party_role))

func set_container_image_data(new_container_image_data : ImageData) -> void:
	container_image_data = new_container_image_data

	$Combos.set("combos_width", self.get_combos_width())
	$Combos.set("combos_height", self.get_combos_height())


#=======================
# Signal Handlers
#=======================



#=======================
# Helpers
#=======================
func position_portrait() -> void:
	var container_height : int = self.container_image_data.get_img_height()
	var portrait_height : int = $Portrait.image_data.get_img_height()
	$Portrait.position.y = (-1) * int((container_height - portrait_height) / 2.0)

func position_element() -> void:
	var container_height : int = self.container_image_data.get_img_height()
	var portrait_height : int = $Portrait.image_data.get_img_height()
	var element_width : int = $Element.image_data.get_img_width()
	var element_height : int = $Element.image_data.get_img_height()
	$Element.position.y = int(container_height / 2.0) - (container_height - portrait_height) + (element_height / 2.0)
	$Element.position.x = (-1) * int(element_width / 2.0)

func position_health() -> void:
	var container_height : int = self.container_image_data.get_img_height()
	var portrait_height : int = $Portrait.image_data.get_img_height()
	var element_height : int = $Element.image_data.get_img_height()
	var health_height : int = $Health.image_data.get_img_height()
	var health_width : int = $Health.image_data.get_img_width()

	var starting_y = (-1) * int(container_height / 2.0) + portrait_height + element_height
	var offset_y = int(health_height / 2.0)

	$Health.position.y = starting_y + offset_y
	$Health.position.x = (-1) * int(health_width / 2.0)

func position_combos() -> void:
	var container_width : int = self.container_image_data.get_img_width()
	var container_height : int = self.container_image_data.get_img_height()
	var portrait_height : int = $Portrait.image_data.get_img_height()
	var remaining_height : int = container_height - portrait_height

	var starting_y : int = (-1) * int(container_height / 2.0) + portrait_height
	var offset_y : int = int(remaining_height / 2.0)
	$Combos.position.y = starting_y + offset_y
	$Combos.position.x = int(container_width / 4.0)

func get_combos_height() -> int:
	var container_height : int = self.container_image_data.get_img_height()
	var portrait_height : int = $Portrait.image_data.get_img_height()

	return container_height - portrait_height

func get_combos_width() -> int:
	var container_width : int = self.container_image_data.get_img_width()
	return int(container_width / 2.0)

func get_portrait_role_name(role_name : String) -> String:
	var portrait_role_name : String = ""
	
	if role_name == PlanConstants.LEAD:
		portrait_role_name = PlanConstants.LEAD
	elif role_name == PlanConstants.STANDBY_TOP:
		portrait_role_name = PlanConstants.STANDBY
	elif role_name == PlanConstants.STANDBY_BOTTOM:
		portrait_role_name = PlanConstants.STANDBY

	return portrait_role_name
