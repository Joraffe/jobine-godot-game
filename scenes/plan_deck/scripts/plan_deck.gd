extends Node2D


var deck_card_scene = preload("res://scenes/plan_deck_card/PlanDeckCard.tscn")

var card_library : Dictionary

var current_deck : Dictionary
var rendered_deck_cards : Dictionary

var container_image_data : ImageData :
	set = set_container_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	PlanRadio.connect(PlanRadio.PLAN_STARTED, _on_plan_started)
	PlanRadio.connect(PlanRadio.PARTY_UPDATED, _on_party_updated)

func _ready() -> void:
	self.set("container_image_data", ImageData.new("plan_deck", "container", "container.png"))


#=======================
# Setters
#=======================
func set_container_image_data(new_container_image_data : ImageData) -> void:
	container_image_data = new_container_image_data

	$Sprite2D.set_texture(self.container_image_data.get_img_texture())


#=======================
# Signal Handlers
#=======================
func _on_plan_started(seed_data : Dictionary) -> void:
	self.set("card_library", seed_data[SeedData.CARDS])

func _on_party_updated(party_data : Dictionary) -> void:
	var characters : Array[Character] = []
	var character_names : Array[String] = []
	for role_name in party_data:
		if party_data[role_name] != null:
			characters.append(party_data[role_name])
			character_names.append(party_data[role_name].machine_name)
	
	var already_rendered_character_names : Array = self.rendered_deck_cards.keys()

	# in the case of adding characters
	if characters.size() > already_rendered_character_names.size():
		for character in characters:
			if character.machine_name not in already_rendered_character_names:
				self.render_character_cards(character)
	# in the case of removing characters
	elif characters.size() < already_rendered_character_names.size():
		for character_name in already_rendered_character_names:
			if character_name not in character_names:
				self.current_deck.erase(character_name)
				self.rerender_deck_cards()

	self.emit_deck_updated()


#=======================
# Helpers
#=======================
func empty_deck_cards_for_character(character_name : String) -> void:
	var rendered : Array[Node2D] = self.rendered_deck_cards[character_name]
	self.rendered_deck_cards.erase(character_name)
	for rendered_deck_card in rendered:
		rendered_deck_card.queue_free()

func render_deck_cards(cards : Array[Card], character : Character) -> void:
	var rendered : Array[Node2D] = []
	self.rendered_deck_cards[character.machine_name] = rendered
	for card in cards:
		var instance : Node2D = deck_card_scene.instantiate()
		instance.set("card", card)
		self.add_child(instance)
		self.position_deck_card(instance)
		self.rendered_deck_cards[character.machine_name].append(instance)

func position_deck_card(instance : Node2D) -> void:
	var index_position : int = self.get_num_rendered_cards()
	var container_image_height : int = self.container_image_data.get_img_height()
	var deck_card_height : int = instance.container_image_data.get_img_height()

	var starting_y : int = (-1) * int(container_image_height / 2.0) 
	var offset_y = int(deck_card_height / 2.0)

	instance.position.y = starting_y + offset_y + (deck_card_height * index_position)

func get_num_rendered_cards() -> int:
	var num : int = 0

	for character_name in self.rendered_deck_cards.keys():
		for deck_card_instance in self.rendered_deck_cards[character_name]:
			num += 1

	return num

func render_character_cards(character : Character) -> void:
	var character_cards : Array[Dictionary] = self.card_library.get(character.machine_name)
	for character_card in character_cards:
		character_card[Card.CHARACTER_INSTANCE_ID] = character.get_instance_id()
	var cards : Array[Card] = Card.create_multi(character_cards)
	self.current_deck[character.machine_name] = {
		PlanConstants.CHARACTER : character,
		PlanConstants.CARDS : cards
	}
	self.render_deck_cards(cards, character)

func remove_character_cards(character_name : String) -> void:
	self.current_deck.erase(character_name)

func rerender_deck_cards() -> void:
	# first empty the existing cards
	for character_name in self.rendered_deck_cards.keys():
		for deck_card in self.rendered_deck_cards[character_name]:
			deck_card.queue_free()

	self.set("rendered_deck_cards", {})
	# then re-render the remaining current_deck
	for character_name in self.current_deck:
		var character_deck_data : Dictionary = self.current_deck[character_name]
		self.render_deck_cards(
			character_deck_data[PlanConstants.CARDS],
			character_deck_data[PlanConstants.CHARACTER]
		)

func emit_deck_updated() -> void:
	PlanRadio.emit_signal(
		PlanRadio.DECK_UPDATED,
		self.current_deck
	)
