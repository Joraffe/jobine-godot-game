extends Node2D


var data : Dictionary  # passed in from SceneSwitcher


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	HubRadio.connect(HubRadio.BATTLE_SELECTED, _on_battle_selected)

func _ready() -> void:
	self.data["seed"] = SeedData.get_seed_data()
	self.data["current_day"] = 1
	self.data["current_time_period"] = "morning"
	HubRadio.emit_signal(HubRadio.HUB_STARTED, self.data)
	self.position_components()


#=======================
# Signal Handlers
#=======================
func _on_battle_selected() -> void:
	SceneSwitcher.goto_scene(
		"res://scenes/battle/Battle.tscn",
		self.data
	)


#=======================
# Helpers
#=======================
func position_components() -> void:
	self.position_background()
	self.position_datetime()
	self.position_research()
	self.position_commune()
	self.position_battle()
	self.position_explore()

func position_background() -> void:
	var offset_x : float = ViewportConstants.SCREEN_WIDTH / 2.0
	var offset_y : float = ViewportConstants.SCREEN_HEIGHT / 2.0
	$Background.set_position(Vector2(offset_x, offset_y))

func position_datetime() -> void:
	var datetime_visual_state : String = $Datetime.visual_state
	if datetime_visual_state == HubConstants.DATETIME_EXPANDED:
		$Datetime.position_as_expanded()
	elif datetime_visual_state == HubConstants.DATETIME_COLLAPSED:
		$Datetime.position_as_collapsed()

func position_research() -> void:
	var research_width : int = $Research.image_data.get_img_width()
	var research_height : int = $Research.image_data.get_img_height()

	var offset_x : float = research_width / 2.0
	var offset_y : float = research_height * 1.5
	$Research.set_position(Vector2(offset_x, offset_y))

func position_commune() -> void:
	var commune_width : int = $Commune.image_data.get_img_width()
	var commune_height : int = $Commune.image_data.get_img_height()

	var offset_x : float = commune_width / 2.0
	var offset_y : float = commune_height / 2.0
	$Commune.set_position(Vector2(offset_x, offset_y))

func position_battle() -> void:
	var battle_width : int = $Battle.image_data.get_img_width()
	var battle_height : int = $Battle.image_data.get_img_height()

	var offset_x : float = battle_width * 1.5
	var offset_y : float = battle_height / 2.0
	$Battle.set_position(Vector2(offset_x, offset_y))

func position_explore() -> void:
	var explore_width : int = $Explore.image_data.get_img_width()
	var explore_height : int = $Explore.image_data.get_img_height()

	var offset_x : float = explore_width * 1.5
	var offset_y : float = explore_height * 1.5
	$Explore.set_position(Vector2(offset_x, offset_y))
