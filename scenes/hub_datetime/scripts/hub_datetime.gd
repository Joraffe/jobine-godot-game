extends Node2D


var should_prevent_collapse : bool


var visual_state : String :
	set = set_visual_state


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	HubRadio.connect(HubRadio.HUB_STARTED, _on_hub_started)
	HubRadio.connect(HubRadio.COLLAPSED_DATETIME_CLICKED, _on_collapsed_datetime_clicked)
	HubRadio.connect(HubRadio.MOUSE_ENTERED_EXPANDED_DATETIME, _on_mouse_entered_expanded_datetime)
	HubRadio.connect(HubRadio.MOUSE_EXITED_EXPANDED_DATETIME, _on_mouse_exited_expanded_datetime)

func _ready() -> void:
	$ExpandedTimer.connect("timeout", _on_expanded_timeout)


#=======================
# Setters
#=======================
func set_visual_state(new_visual_state : String) -> void:
	visual_state = new_visual_state

	if self.visual_state == HubConstants.DATETIME_EXPANDED:
		$Expanded.show()
	elif self.visual_state == HubConstants.DATETIME_COLLAPSED:
		$Collapsed.show()


#=======================
# Signal Handlers
#=======================
func _on_hub_started(_hub_data : Dictionary) -> void:
	self.set("visual_state", HubConstants.DATETIME_EXPANDED)
	$ExpandedTimer.start()

func _on_expanded_timeout() -> void:
	if not self.should_prevent_collapse:
		self.tween_collapse()

func _on_mouse_entered_expanded_datetime() -> void:
	self.set("should_prevent_collapse", true)

func _on_mouse_exited_expanded_datetime() -> void:
	self.set("should_prevent_collapse", false)
	$ExpandedTimer.start()

func _on_collapsed_datetime_clicked() -> void:
	$Collapsed.hide()
	$Expanded.show()
	self.position_as_expanded()
	self.tween_expand()


#=======================
# Helpers
#=======================
func tween_collapse() -> void:
	var tween = self.create_tween()
	var expanded_height : int = $Expanded.image_data.get_img_height()
	var offscreen_y : float = (-1) * expanded_height
	tween.tween_property($Expanded, "position:y", offscreen_y, 1)
	tween.tween_callback($Expanded.hide)
	tween.tween_callback(self.position_as_collapsed)
	tween.tween_callback($Collapsed.show)

func tween_expand() -> void:
	var tween = self.create_tween()
	tween.tween_property($Expanded, "position:y", 0, 1)

func position_as_collapsed() -> void:
	var collapsed_width : int = $Collapsed.image_data.get_img_width()
	var collapsed_height : int = $Collapsed.image_data.get_img_height()
	self.set_position(Vector2(collapsed_width / 2.0, collapsed_height / 2.0))

func position_as_expanded() -> void:
	var expanded_width : int = $Expanded.image_data.get_img_width()
	var expanded_height : int = $Expanded.image_data.get_img_height()
	self.set_position(Vector2(expanded_width / 2.0, expanded_height / 2.0))
