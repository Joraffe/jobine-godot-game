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
