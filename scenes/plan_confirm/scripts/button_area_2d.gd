extends Area2D


var is_mouse_over_button : bool
var is_button_enabled : bool

var button_image_data : ImageData :
	set = set_button_image_data

var disabled_image_data : ImageData = ImageData.new(
	"plan_confirm",
	"button_disabled",
	"button_disabled.png"
)
var enabled_image_data : ImageData = ImageData.new(
	"plan_confirm",
	"button_enabled",
	"button_enabled.png"
)


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PARTY_FILLED, _on_party_filled)
	PlanRadio.connect(PlanRadio.PARTY_UNFILLED, _on_party_unfilled)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


#=======================
# Setters
#=======================
func set_button_image_data(new_button_image_data : ImageData) -> void:
	button_image_data = new_button_image_data

	$ButtonSprite2D.set_texture(self.button_image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_party_filled() -> void:
	self.set("button_image_data", self.enabled_image_data)
	self.set("is_button_enabled", true)

func _on_party_unfilled() -> void:
	self.set("button_image_data", self.disabled_image_data)
	self.set("is_button_enabled", false)

func _on_mouse_entered() -> void:
	self.set("is_mouse_over_button", true)

func _on_mouse_exited() -> void:
	self.set("is_mouse_over_button", false)

func _input(event) -> void:
	if not self.is_mouse_over_button:
		return

	if not self.is_button_enabled:
		return

	if self.is_left_mouse_click(event):
		self.emit_plan_confirmed()


#=======================
# Helpers
#=======================
func is_left_mouse_click(event) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

func emit_plan_confirmed() -> void:
	PlanRadio.emit_signal(PlanRadio.PLAN_CONFIRMED)
