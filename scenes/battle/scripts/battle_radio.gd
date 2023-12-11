extends Node

 
# Overall Battle Related
signal battle_started(battle_data : BattleData)


# BattleArena Related
signal card_targeting_enabled
signal card_targeting_disabled


# Deck Related
signal card_drawn(card : Card)
signal cards_drawn(cards : Array[Card])


# Hand Related
signal hand_filled


# Swap Related
signal character_swapped(character : Character, swap_position : String)
signal current_lead_updated(current_lead : Character)
signal current_swaps_updated(current_swaps : int)


# Enemy Related
signal enemy_target_selected(enemy : Enemy)
signal enemy_damaged(enemy : Enemy, damage : int)
signal enemy_element_applied(
	enemy : Enemy,
	applied_element_name : String,
	num_applied_element : int
)


# Card Related
signal card_selected(card : Card)
signal card_deselected(card : Card)
signal card_played(card : Card, targeting : Targeting)


# Turn Related
signal player_turn_started
signal player_turn_ended


# Energy Related
signal energy_gained(amount: int)
signal energy_spent(amount : int)
signal current_energy_updated(current_energy : int)


# Elements Related
signal elements_combined(combo_data : Dictionary)


# Combo Related
signal combo_applied(combo_data : Dictionary)
signal combo_bonus_applied(combo_bonus_data : Dictionary)


#=====================
# Signal String names
#=====================
const BATTLE_STARTED : String = "battle_started"


const CARD_TARGETING_ENABLED : String = "card_targeting_enabled"
const CARD_TARGETING_DISABLED : String = "card_targeting_disabled"


const CARD_DRAWN : String = "card_drawn"
const CARDS_DRAWN : String = "cards_drawn"


const HAND_FILLED : String = "hand_filled"


const CHARACTER_SWAPPED : String = "character_swapped"
const CURRENT_SWAPS_UPDATED : String = "current_swaps_updated"
const CURRENT_LEAD_UPDATED : String = "current_lead_updated"


const ENEMY_TARGET_SELECTED : String = "enemy_target_selected"
const ENEMY_DAMAGED : String = "enemy_damaged"
const ENEMY_ELEMENT_APPLIED : String = "enemy_element_applied"


const CARD_SELECTED : String = "card_selected"
const CARD_DESELECTED : String = "card_deselected"
const CARD_PLAYED : String = "card_played"


const PLAYER_TURN_STARTED : String = "player_turn_started"
const PLAYER_TURN_ENDED : String = "player_turn_ended"


const ENERGY_GAINED : String = "energy_gained"
const ENERGY_SPENT : String = "energy_spent"
const CURRENT_ENERGY_UPDATED : String = "current_energy_updated"


const ELEMENTS_COMBINED : String = "elements_combined"


const COMBO_APPLIED : String = "combo_applied"
const COMBO_BONUS_APPLIED : String = "combo_bonus_applied"
