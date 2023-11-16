extends Node

@export var hand_data : HandData
var hand_image_data : ImageData


# Called when the node enters the scene tree for the first time.
func _ready():
	hand_image_data = ImageData.new("hand", "empty_hand.png")
