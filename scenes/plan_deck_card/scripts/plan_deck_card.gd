extends Node2D


var card : Card :
	set = set_card
var card_name : String :
	set = set_card_name
var card_cost : int :
	set = set_card_cost

var container_image_data : ImageData :
	set = set_container_image_data
var art_image_data : ImageData :
	set = set_art_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	pass


#=======================
# Setters
#=======================
func set_card(new_card : Card) -> void:
	card = new_card

	self.set("card_name", self.card.human_name)
	self.set("card_cost", self.card.cost)
	self.set("container_image_data", self.get_container_image_data(self.card))
	self.set("art_image_data", self.get_art_image_data(self.card))

func set_card_name(new_card_name : String) -> void:
	card_name = new_card_name

	$ContainerSprite2D/Panel/NameLabel.set_text("{name}".format({"name" : self.card_name}))

func set_card_cost(new_card_cost : int) -> void:
	card_cost = new_card_cost

	$ContainerSprite2D/CostLabel.set_text("   {cost}".format({"cost" : self.card_cost}))

func set_container_image_data(new_container_image_data : ImageData) -> void:
	container_image_data = new_container_image_data

	$ContainerSprite2D.set_texture(self.container_image_data.get_img_texture())
	

func set_art_image_data(new_art_image_data : ImageData) -> void:
	art_image_data = new_art_image_data

	$ContainerSprite2D/ArtSprite2D.set_texture(self.art_image_data.get_img_texture())


#=======================
# Helpers
#=======================
func get_container_image_data(_card : Card) -> ImageData:
	return ImageData.new(
		"plan_deck_card",
		"container",
		"{element}.png".format({"element" : _card.element_name})
	)

func get_art_image_data(_card : Card) -> ImageData:
	return ImageData.new(
		"plan_deck_card",
		"art",
		"{name}.png".format({"name" : _card.machine_name})
	)
