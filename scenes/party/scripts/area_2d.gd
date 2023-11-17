extends Area2D

@onready var party = get_parent()


var character_scene = preload("res://scenes/character/scenes/Character.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	BattleRadio.connect("start_battle", _on_start_battle)
	$Sprite2D.set_texture(party.image_data.get_img_texture())


func _on_start_battle():
	render_party()


func render_party():
	print('render_party called because of `start_battle` event emitted')


func instantiate_character(character_data: CharacterData):
	pass


func position_character_in_party(index, card_instance):
	pass
