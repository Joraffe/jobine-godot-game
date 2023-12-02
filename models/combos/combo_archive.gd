extends Resource
class_name ComboArchive


static func get_combo(name : String) -> Combo:
	match name:
		STEAM_COMBO:
			return Combo.new(STEAM_COMBO)
		GROW_COMBO:
			return Combo.new(GROW_COMBO)
		BURN_COMBO:
			return Combo.new(BURN_COMBO)
		_:
			return Combo.new(UNKNOWN_COMBO)


#=========================
#     List of Combos
#=========================
const STEAM_COMBO : String = "steam_combo" # water + fire
const GROW_COMBO : String = "grow_combo" # water + nature
const BURN_COMBO : String = "burn_combo" # nature + fire
const UNKNOWN_COMBO : String = "unknown_combo"
