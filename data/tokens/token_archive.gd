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
	var tokens : Array[Token] = []
	for token_name in token_names:
		tokens.append(TokenArchive.get_token(token_name))

	return tokens

#=======================
# Token Types + Effects
#=======================
const FIRE_TOKEN : String = "fire_token"
const WATER_TOKEN : String = "water_token"
const NATURE_TOKEN : String = "nature_token"
const UNKNOWN_TOKEN : String = "unknown_token"
