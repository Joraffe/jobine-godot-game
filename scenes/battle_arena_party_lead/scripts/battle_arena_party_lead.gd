extends Node2D


var lead_character : Character :
	set = set_lead_character


var image_data : ImageData = ImageData.new(
	"battle_arena_party_lead",
	"empty",
	"party_lead.png"
)


#=======================
# Setters
#=======================
func set_lead_character(new_character : Character) -> void:
	lead_character = new_character
	BattleRadio.emit_signal(
		BattleRadio.CURRENT_LEAD_UPDATED,
		self.lead_character
	)
	$Area2D.empty_lead()
	$Area2D.render_lead()
