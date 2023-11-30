extends Node

 
# Overall Battle Related
signal battle_started(battle_data : BattleData)


# BattleArena Related
signal card_targeting_enabled(card_data : BattleFieldCardData)
signal card_targeting_disabled(card_data : BattleFieldCardData)


# Deck Related
signal card_drawn(card_data : BattleFieldCardData)


# Hand Related
signal hand_filled


# Swap Related
signal character_swapped(swap_member_data : BattleFieldSwapMemberData)


# Card Related
signal card_selected(card_data : BattleFieldCardData)
signal card_deselected(card_data : BattleFieldCardData)
