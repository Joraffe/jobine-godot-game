extends Node

 
# Overall Battle Related
signal battle_started(battle_data : BattleData)


# BattleArena Related
signal card_targeting_enabled
signal card_targeting_disabled


# Deck Related
signal card_drawn(card : Card)


# Hand Related
signal hand_filled


# Swap Related
signal character_swapped(character : Character, swap_position : String)


# Card Related
signal card_selected(card : Card)
signal card_deselected(card : Card)


# Turn Related
signal player_turn_started
signal player_turn_ended


# Energy Related
signal energy_gained(amount: int)
signal energy_spent(amount : int)


#=====================
# Signal String names
#=====================
const BATTLE_STARTED : String = "battle_started"
const CARD_TARGETING_ENABLED : String = "card_targeting_enabled"
const CARD_TARGETING_DISABLED : String = "card_targeting_disabled"
const CARD_DRAWN : String = "card_drawn"
const HAND_FILLED : String = "hand_filled"
const CHARACTER_SWAPPED : String = "character_swapped"
const CARD_SELECTED : String = "card_selected"
const CARD_DESELECTED : String = "card_deselected"
const PLAYER_TURN_STARTED : String = "player_turn_started"
const PLAYER_TURN_ENDED : String = "player_turn_ended"
const ENERGY_GAINED : String = "energy_gained"
const ENERGY_SPENT : String = "energy_spent"
