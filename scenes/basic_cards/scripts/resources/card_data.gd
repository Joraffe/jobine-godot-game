extends Resource
class_name CardData

@export var card_name : String


func _init(_card_name):
	card_name = _card_name


func get_card_image_path():
	var fmt_path = "res://scenes/basic_cards/resources/images/{card_name}.png"
	return fmt_path.format({"card_name": card_name})
