extends Resource
class_name CharacterArchive

# ================
# Temp Characters
# ================
const EVIL_PETTEL : String = "evil_pettel"
const SCREM_PETTEL : String = "screm_pettel"
const FLAT_PETTEL : String = "flat_pettel"


# ===================
# Actual Characters
# ===================
static func get_character(name : String) -> Character:
	match name:
		JUNO_CHARACTER:
			return Character.new(
				JUNO_CHARACTER,
				ElementArchive.NATURE_ELEMENT,
				10,
				10
			)
		PETTOL_CHARACTER:
			return Character.new(
				PETTOL_CHARACTER,
				ElementArchive.WATER_ELEMENT,
				15,
				15
			)
		AXO_CHARACTER:
			return Character.new(
				AXO_CHARACTER,
				ElementArchive.FIRE_ELEMENT,
				7,
				7
			)
		_:
			return Character.new(
				UNKNOWN_CHARACTER,
				ElementArchive.UNKNOWN_ELEMENT,
				0,
				0
			)

#=========================
#   List of Characters
#=========================
const JUNO_CHARACTER : String = "juno_character"
const PETTOL_CHARACTER : String = "pettol_character"
const AXO_CHARACTER : String = "axo_character"
const UNKNOWN_CHARACTER : String = "unknown_character"
