extends Node

 
# Overall Battle Related
signal battle_started(battle_data : BattleData)


# BattleArena Related
signal card_targeting_enabled
signal card_targeting_disabled


# Deck Related
signal card_drawn(card : Card)
signal cards_drawn(cards : Array[Card])
signal deck_emptied


# Discard Related
signal discard_pile_shuffled_into_deck


# Hand Related
signal hand_filled
signal current_hand_size_updated(current_hand_size_updated : int)


# Swap Related
signal character_swapped(character : Character, swap_position : String)
signal current_lead_updated(current_lead : Character)
signal current_swaps_updated(current_swaps : int)


# Enemy Related
signal enemy_target_selected(enemy : Enemy)
signal enemy_damaged(enemy : Enemy, damage : int)
signal enemy_element_applied(enemy : Enemy, element_name : String, num_applied : int)
signal enemy_attack_queued(enemy : Enemy, attack : EnemyAttack)
signal enemy_attack_finished


# Lead Related
signal lead_damaged(damage : int)
signal lead_element_applied(element_name : String, num_applied : int)


# Character Related
signal character_damaged(character : Character, damage : int)
signal character_element_applied(character : Character, element_name : String, num_applied : int)


# Card Related
signal card_selected(card : Card)
signal card_deselected(card : Card)
signal card_played(card : Card, targeting : Targeting)
signal card_discarded(card : Card)


# Turn Related
signal player_turn_started
signal player_turn_ended
signal enemy_turn_started
signal enemy_turn_ended


# Energy Related
signal energy_gained(amount: int)
signal energy_spent(amount : int)
signal current_energy_updated(current_energy : int)


# Elements Related
signal elements_combined(
	instance_id : int,
	first_element_index : int,
	second_element_index : int
)
signal elements_settled


# Entity Related
signal entity_damaged(instance_id : int, damage : int)
signal element_applied_to_entity(
	instance_id : int,
	element_name : String,
	amount_applied : int
)
signal elements_removed_from_entity(
	instance_id : int,
	removed_element_indexes : Array[int]
)
signal entity_current_hp_updated(instance_id : int, new_current_hp : int)
signal entity_current_element_names_updated(
	instance_id : int,
	new_current_element_names
)

# Combo Related
signal combo_applied(instance_id : int, combo : Combo)
signal combos_applied(instance_id : int, combos : Array[Combo])
signal combo_bonus_applied(
	instance_id : int,
	combo_bonus : ComboBonus,
	targeting : Targeting
)


#=====================
# Signal String names
#=====================
const BATTLE_STARTED : String = "battle_started"


const CARD_TARGETING_ENABLED : String = "card_targeting_enabled"
const CARD_TARGETING_DISABLED : String = "card_targeting_disabled"


const CARD_DRAWN : String = "card_drawn"
const CARDS_DRAWN : String = "cards_drawn"
const DECK_EMPTIED : String = "deck_emptied"


const DISCARD_PILE_SHUFFLED_INTO_DECK : String = "discard_pile_shuffled_into_deck"


const HAND_FILLED : String = "hand_filled"
const CURRENT_HAND_SIZE_UPDATED : String = "current_hand_size_updated"


const CHARACTER_SWAPPED : String = "character_swapped"
const CURRENT_SWAPS_UPDATED : String = "current_swaps_updated"
const CURRENT_LEAD_UPDATED : String = "current_lead_updated"


const ENEMY_TARGET_SELECTED : String = "enemy_target_selected"
const ENEMY_DAMAGED : String = "enemy_damaged"
const ENEMY_ELEMENT_APPLIED : String = "enemy_element_applied"
const ENEMY_ATTACK_QUEUED : String = "enemy_attack_queued"
const ENEMY_ATTACK_FINISHED : String = "enemy_attack_finished"


const ENTITY_DAMAGED : String = "entity_damaged"
const ELEMENT_APPLIED_TO_ENTITY : String = "element_applied_to_entity"
const ELEMENTS_REMOVED_FROM_ENTITY : String = "elements_removed_from_entity"
const ENTITY_CURRENT_HP_UPDATED : String = "entity_current_hp_updated"
const ENTITY_CURRENT_ELEMENT_NAMES_UPDATED : String = "entity_current_element_names_updated"


const LEAD_DAMAGED : String = "lead_damaged"
const LEAD_ELEMENT_APPLIED : String = "lead_element_applied"


const CHARACTER_DAMAGED : String = "character_damaged"
const CHARACTER_ELEMENT_APPLIED : String = "character_element_applied"


const CARD_SELECTED : String = "card_selected"
const CARD_DESELECTED : String = "card_deselected"
const CARD_PLAYED : String = "card_played"
const CARD_DISCARDED : String = "card_discarded"


const PLAYER_TURN_STARTED : String = "player_turn_started"
const PLAYER_TURN_ENDED : String = "player_turn_ended"
const ENEMY_TURN_STARTED : String = "enemy_turn_started"
const ENEMY_TURN_ENDED : String = "enemy_turn_ended"


const ENERGY_GAINED : String = "energy_gained"
const ENERGY_SPENT : String = "energy_spent"
const CURRENT_ENERGY_UPDATED : String = "current_energy_updated"


const ELEMENTS_COMBINED : String = "elements_combined"
const ELEMENTS_SETTLED : String = "elements_settled"


const COMBO_APPLIED : String = "combo_applied"
const COMBOS_APPLIED : String = "combos_applied"
const COMBO_BONUS_APPLIED : String = "combo_bonus_applied"
