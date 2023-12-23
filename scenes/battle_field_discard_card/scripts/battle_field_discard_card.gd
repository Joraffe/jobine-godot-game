extends Node2D


var image_data : ImageData = ImageData.new(
	"battle_field_discard_card",
	"card",
	"discard_card.png"
)


func _ready():
	$Sprite2D.set_texture(self.image_data.get_img_texture())
