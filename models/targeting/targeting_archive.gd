extends Resource
class_name TargetingArchive


static func get_targeting(name : String) -> Targeting:
	match name:
		PARTY_SINGLE_TARGETING:
			return Targeting.new(PARTY_SINGLE_TARGETING, 1, false)
		PARTY_ALL_TARGETING:
			return Targeting.new(PARTY_ALL_TARGETING, 0 , true)
		ENEMIES_SINGLE_TARGETING:
			return Targeting.new(ENEMIES_SINGLE_TARGETING, 1, false)
		ENEMIES_ALL_TAGETING:
			return Targeting.new(ENEMIES_ALL_TAGETING, 0, true)
		_:
			return Targeting.new(UNKNOWN_TARGETING, 0, false)


#=======================
#    Targeting Types
#=======================
const PARTY_SINGLE_TARGETING : String = "party_single_target"
const PARTY_ALL_TARGETING : String = "party_all_targeting"

const ENEMIES_SINGLE_TARGETING : String = "enemies_single_targeting"
const ENEMIES_ALL_TAGETING : String = "enemies_all_targeting"

const UNKNOWN_TARGETING : String = "unknown_targeting"
