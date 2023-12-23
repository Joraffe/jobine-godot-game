extends Node2D


var lead_instance_id : int :
	set = set_lead_instance_id
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
	self.set("lead_instance_id", self.lead_character.get_instance_id())
	$Area2D.empty_lead()
	$Area2D.render_lead()


func set_lead_instance_id(new_instance_id : int) -> void:
	lead_instance_id = new_instance_id

	BattleRadio.emit_signal(
		BattleRadio.CURRENT_LEAD_UPDATED,
		self.lead_instance_id
	)


#========================
# Helpers
#========================
func is_applicable_to_lead_character(instance_id : int) -> bool:
	return instance_id == self.lead_character.get_instance_id()

func is_applicable_to_lead(instance_id : int) -> bool:
	return instance_id == self.get_instance_id()

func request_next_lead() -> void:
	BattleRadio.emit_signal(
		BattleRadio.NEXT_LEAD_STATS_REQUESTED,
		self.get_instance_id()
	)
