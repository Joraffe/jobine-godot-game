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
