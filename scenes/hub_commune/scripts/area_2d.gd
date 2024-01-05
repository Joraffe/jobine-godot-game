extends Area2D


var is_mouse_over_art : bool

var image_data : ImageData :
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)

func _ready() -> void:
	self.set("image_data", ImageData.new("hub_commune", "art", "art.png"))


#=======================
# Setters
#=======================
func set_image_data(new_image_data : ImageData) -> void:
	image_data = new_image_data

	$Sprite2D.set_texture(self.image_data.get_img_texture())


#=======================
# Signal Handers
#=======================
func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	self.set("is_mouse_over_art", true)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	self.set("is_mouse_over_art", false)

func _input(event) -> void:
	if not self.is_mouse_over_art:
		return

	if not self.is_left_mouse_click(event):
		return

	if self.is_left_mouse_click(event):
		self.emit_commune_selected()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return


#=======================
# Helpers
#=======================
func is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

func emit_commune_selected() -> void:
	HubRadio.emit_signal(HubRadio.COMMUNE_SELECTED)
