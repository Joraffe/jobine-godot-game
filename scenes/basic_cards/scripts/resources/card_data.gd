extends Resource
class_name CardData

@export var card_name : String


func get_card_image_path():
	var fmt_path = "res://scenes/basic_cards/resources/images/{card_name}.png"
	return fmt_path.format({"card_name": card_name})
