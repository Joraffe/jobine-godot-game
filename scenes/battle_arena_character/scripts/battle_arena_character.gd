extends Node2D


var character : Character:
	set = set_character

var image_data : ImageData:
	set = set_image_data


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.CHARACTER_DAMAGED, _on_damaged)
	BattleRadio.connect(BattleRadio.CHARACTER_ELEMENT_APPLIED, _on_element_applied)


#=======================
# Setters
#=======================
func set_character(new_character : Character) -> void:
	character = new_character

	# Also set the character_image_data
	self.set(
		"image_data",
		ImageData.new(
			"battle_arena_character", # scene
			self.character.machine_name,  # instance
			"{name}.png".format({"name": self.character.machine_name})  # filename
		)
	)
	$HealthBar.set("entity", self.character)
	$Aura.set("entity", self.character)
	$Combo.set("entity", self.character)

func set_image_data(new_image_data : ImageData):
	image_data = new_image_data
	$Area2D/Sprite2D.set_texture(self.image_data.get_img_texture())
	$Aura.set("aura_width", self.image_data.get_img_width())


#=======================
# Signal Handlers
#=======================
func _on_damaged(damaged_character : Character, damage : int) -> void:
	if damaged_character != self.character:
		return

	$HealthBar.take_damage(damage)

func _on_element_applied(
	applied_character : Character,
	applied_element_name : String,
	num_applied_element : int
) -> void:
	if applied_character != self.character:
		return

	for i in range(num_applied_element):
		$Aura.apply_element(Element.by_machine_name(applied_element_name))
