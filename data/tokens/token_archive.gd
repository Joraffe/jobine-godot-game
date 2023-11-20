extends Resource
class_name TokenArchive


static func get_token(name : String) -> Token:
	match name:
		FIRE_TOKEN:
			return Token.new(FIRE_TOKEN)
		WATER_TOKEN:
			return Token.new(WATER_TOKEN)
		NATURE_TOKEN:
			return Token.new(NATURE_TOKEN)
		_:
			return Token.new(UNKNOWN_TOKEN)


static func get_tokens(token_names : Array[String]) -> Array[Token]:
	return token_names.map(get_token)


#=======================
# Token Types + Effects
#=======================
const FIRE_TOKEN : String = "fire_token"
const WATER_TOKEN : String = "water_token"
const NATURE_TOKEN : String = "nature_token"
const UNKNOWN_TOKEN : String = "unknown_token"
