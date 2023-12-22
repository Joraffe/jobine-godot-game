extends Node

 
# Overall Battle Related
const BATTLE_STARTED : String = "battle_started"
signal battle_started(battle_data : BattleData)


# BattleArena Related
const CARD_TARGETING_ENABLED : String = "card_targeting_enabled"
const CARD_TARGETING_DISABLED : String = "card_targeting_disabled"
signal card_targeting_enabled
signal card_targeting_disabled


# Deck Related
const CARD_DRAWN : String = "card_drawn"
const CARDS_DRAWN : String = "cards_drawn"
const DECK_EMPTIED : String = "deck_emptied"
signal card_drawn(card : Card)
signal cards_drawn(cards : Array[Card])
signal deck_emptied


# Discard Related
const DISCARD_PILE_SHUFFLED_INTO_DECK : String = "discard_pile_shuffled_into_deck"
signal discard_pile_shuffled_into_deck


# Hand Related
const HAND_FILLED : String = "hand_filled"
const CURRENT_HAND_SIZE_UPDATED : String = "current_hand_size_updated"
signal hand_filled
signal current_hand_size_updated(current_hand_size_updated : int)


# Swap Related
const CURRENT_SWAPS_UPDATED : String = "current_swaps_updated"
signal current_swaps_updated(current_swaps : int)
const CURRENT_LEAD_UPDATED : String = "current_lead_updated"
signal current_lead_updated(current_lead_instance_id : int)


# Enemy Related
const ENEMY_TARGET_SELECTED : String = "enemy_target_selected"
const ENEMY_DAMAGED : String = "enemy_damaged"
const ENEMY_ELEMENT_APPLIED : String = "enemy_element_applied"
const ENEMY_ATTACK_QUEUED : String = "enemy_attack_queued"
const ENEMY_ATTACK_FINISHED : String = "enemy_attack_finished"
signal enemy_target_selected(enemy : Enemy)
signal enemy_damaged(enemy : Enemy, damage : int)
signal enemy_element_applied(enemy : Enemy, element_name : String, num_applied : int)
signal enemy_attack_queued(enemy : Enemy, attack : EnemyAttack)
signal enemy_attack_finished
const ENEMY_DEFEATED_ANIMATION_QUEUED : String = "enemy_defeated_animation_queued"
signal enemy_defeated_animation_queued(instance_id : int)
const ENEMY_DEFEATED_ANIMATION_FINISHED : String = "enemy_defeated_animation_finished"
signal enemy_defeated_animation_finished(instance_id : int)


# Lead Related
const LEAD_DAMAGED_BY_ENEMY : String = "lead_damaged_by_enemy"
signal lead_damaged_by_enemy(enemy_instance_id : int, damage : int)
const ELEMENTS_ADDED_TO_LEAD_BY_ENEMY : String = "elements_added_to_lead_by_enemy"
signal elements_added_to_lead_by_enemy(element_name : String, amount : int)



# Character Related
const CHARACTER_DAMAGED : String = "character_damaged"
const CHARACTER_ELEMENT_APPLIED : String = "character_element_applied"
const CHARACTER_FAINTED : String = "character_fainted"
signal character_damaged(character : Character, damage : int)
signal character_element_applied(character : Character, element_name : String, num_applied : int)
signal character_fainted(instance_id : int)


# Card Related
const CARD_SELECTED : String = "card_selected"
const CARD_DESELECTED : String = "card_deselected"
const CARD_PLAYED : String = "card_played"
const CARD_DISCARDED : String = "card_discarded"
const CARD_FREED : String = "card_freed"
signal card_selected(card : Card)
signal card_deselected(card : Card)
signal card_played(card : Card)
signal card_discarded(card : Card)
signal card_freed(card : Card)


# Turn Related
const PLAYER_TURN_STARTED : String = "player_turn_started"
const PLAYER_TURN_ENDED : String = "player_turn_ended"
const ENEMY_TURN_STARTED : String = "enemy_turn_started"
const ENEMY_TURN_ENDED : String = "enemy_turn_ended"
signal player_turn_started
signal player_turn_ended
signal enemy_turn_started
signal enemy_turn_ended


# Energy Related
const ENERGY_GAINED : String = "energy_gained"
const ENERGY_SPENT : String = "energy_spent"
const CURRENT_ENERGY_UPDATED : String = "current_energy_updated"
signal energy_gained(amount: int)
signal energy_spent(amount : int)
signal current_energy_updated(current_energy : int)


# Elements Related
const ELEMENTS_COMBINED : String = "elements_combined"
const ELEMENTS_SETTLED : String = "elements_settled"
signal elements_combined(
	instance_id : int,
	first_element_index : int,
	second_element_index : int
)
signal elements_settled(instance_id : int)


# Entity Related
const ENTITY_DAMAGED : String = "entity_damaged"
const ELEMENT_APPLIED_TO_ENTITY : String = "element_applied_to_entity"
const ELEMENTS_REMOVED_FROM_ENTITY : String = "elements_removed_from_entity"
const ENTITY_CURRENT_HP_UPDATED : String = "entity_current_hp_updated"
const ENTITY_CURRENT_ELEMENT_NAMES_UPDATED : String = "entity_current_element_names_updated"
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
const ENTITY_FAINED : String = "entity_fainted"
signal entity_fainted(instance_id : int)


# Combo Related
const COMBO_APPLIED : String = "combo_applied"
const COMBOS_APPLIED : String = "combos_applied"
const COMBO_BONUS_APPLIED : String = "combo_bonus_applied"
signal combo_applied(instance_id : int, combo : Combo)
signal combos_applied(instance_id : int, combos : Array[Combo])
signal combo_bonus_applied(
	instance_id : int,
	combo_bonus : ComboBonus,
	targeting : Targeting
)


# Enemy Attack Related
const ENEMY_ATTACK_ANIMATION_QUEUED : String = "enemy_attack_animation_queued"
const ENEMY_ATTACK_ANIMATION_FINISHED : String = "enemy_attack_animation_finished"
const ENEMY_ATTACK_EFFECT_QUEUED : String = "enemy_attack_effect_queued"
const ENEMY_ATTACK_EFFECT_RESOLVED : String = "enemy_attack_effect_resolved"
const ENEMY_ATTACK_EFFECT_FINISHED : String = "enemy_attack_effect_finished"
const ENEMY_ATTACK_ELEMENTS_SETTLED : String = "enemy_attack_elements_settled"
signal enemy_attack_animation_queued(enemy_instance_id : int, attack : EnemyAttack)
signal enemy_attack_animation_finished
signal enemy_attack_effect_queued(enemy_instance_id : int, attack_effect_data : Dictionary)
signal enemy_attack_effect_resolved(enemy_instance_id : int, resolve_data : Dictionary)
signal enemy_attack_effect_finished(finish_data : Dictionary)
signal enemy_attack_elements_settled


# Element application related
const ELEMENTS_REMOVED_FROM_ENTITY_RESOLVED : String = "elements_removed_from_entity_resolved"
signal elements_removed_from_entity_resolved(instance_id : int)


# Stats related
const NEXT_LEAD_STATS_REQUESTED : String = "next_lead_stats_requested"
signal next_lead_stats_requested(requester_instance_id : int)
const NEXT_LEAD_STATS_RESPONDED : String = "next_lead_stats_responded"
signal next_lead_stats_responded(requester_instance_id : int, stats : Dictionary)


# Element Animations
const ADD_ELEMENTS_ANIMATION_QUEUED : String = "add_elements_animation_queued"
signal add_elements_animation_queued(instance_id : int, added_element_names : Array[String])
const ADD_ELEMENTS_ANIMATION_FINISHED : String = "add_elements_animation_finished"
signal add_elements_animation_finished(instance_id : int)
const REMOVE_ELEMENTS_ANIMATION_QUEUED : String = "remove_elements_animation_queued"
signal remove_elements_animation_queued(instance_id : int, removed_indexes : Array[int])
const REMOVE_ELEMENTS_ANIMATION_FINISHED : String = "remove_elements_animation_finished"
signal remove_elements_animation_finished(instance_id : int)
const REPOSITION_ELEMENTS_ANIMATION_QUEUED : String = "reposition_elements_animation_queued"
signal reposition_elements_animation_queued(
	instance_id : int,
	old_element_names : Array[String],
	remove_indexes : Array[int],
	remain_indexes : Array[int]
)
const REPOSITION_ELEMENTS_ANIMATION_FINISHED : String = "reposition_elements_animation_finished"
signal reposition_elements_animation_finished(instance_id : int)


# Combo v2
const COMBO_ANIMATION_QUEUED : String = "combo_animation_queued"
signal combo_animation_queued(instance_id : int, combo : Combo)
const COMBO_ANIMATION_FINISHED : String = "combo_animation_finished"
signal combo_animation_finished(instance_id : int)
const COMBO_EFFECT_QUEUED : String = "combo_effect_queued"
signal combo_effect_queued(instance_id : int, combo : Combo)
const COMBO_EFFECT_FINISHED : String = "combo_effect_finished"
signal combo_effect_finished(instance_id : int, finish_data : Dictionary)


# Combo Bonus v2
const COMBO_BONUS_EFFECT_QUEUED : String = "combo_bonus_effect_queued"
const COMBO_BONUS_EFFECT_RESOLVED : String  = "combo_bonus_effect_resolved"
const COMBO_BONUS_EFFECT_FINISHED : String = "combo_bonus_effect_finished"
signal combo_bonus_effect_finished(instance_id : int, finish_data : Dictionary)


# Standby related
const STANDBY_SWAP_TO_LEAD_QUEUED : String = "standby_swap_to_lead_queued"
signal standby_swap_to_lead_queued(standby_instance_id : int)
const STANDBY_SWAP_TO_LEAD_FINISHED : String = "standby_swap_to_lead_finished"
signal standby_swap_to_lead_finished


# Effect related (damage, adding elements, added status effect, etc)
const EFFECTS_ENQUEUED : String = "effects_enqueued"
signal effects_enqueued(
	effector_instance_id : int,
	target_instance_id : int,
	effects : Array[Dictionary]
)
const NEXT_EFFECT_QUEUED : String = "next_effect_queued"
signal next_effect_queued(effector_instance_id : int)
const EFFECT_RESOLVED : String = "effect_resolved"
signal effect_resolved(effector_instance_id : int, resolve_data : Dictionary)
const EFFECTS_FINISHED : String = "effects_finished"
signal effects_finished(effector_instance_id : int)


const ENTITY_DAMAGED_BY_EFFECT : String = "entity_damaged_by_effect"
signal entity_damaged_by_effect(
	effector_instance_id : int,
	entity_instance_id : int,
	damage : int
)
const ADD_ELEMENTS_TO_ENTITY_BY_EFFECT : String = "add_elements_to_entity_by_effect"
signal add_elements_to_entity_by_effect(
	effector_instance_id : int,
	entity_instance_id : int,
	element_name : String,
	amount : int
)

const COMBO_EFFECTS_DEFERRED_TO_GROUP : String  = "combo_effects_deferred_to_group"
signal combo_effects_deferred_to_group(group_name : String, combiner : Combiner)
const CARD_EFFECTS_DEFERRED_TO_GROUP : String = "card_effects_deferred_to_group"
signal card_effects_deferred_to_group(
	group_name : String,
	card : Card,
	card_target_instance_id : int
)
const COMBO_BONUS_EFFECTS_DEFERRED_TO_GROUP : String = "combo_bonus_effects_deferred_to_group"
signal combo_bonus_effects_deferred_to_group(
	group_name : String,
	combo_bonus : ComboBonus,
	primary_target_instance_id : int
)
const COMBO_BONUS_CHECK_DEFERRED : String ="combo_bonus_check_deferred"
signal combo_bonus_check_deferred(combiner : Combiner, target_instance_id : int)
const SELF_NON_TARGETING_COMBO_BONUS_APPLIED : String = "self_non_targeting_combo_bonus_applied"
signal self_non_targeting_combo_bonus_applied(combo_bonus : ComboBonus)
const COMBO_BONUS_ENERGY_GAINED : String = "combo_bonus_energy_gained"
signal combo_bonus_energy_gained(energy_gained : int)
const COMBO_BONUS_SWAPS_GAINED : String = "combo_bonus_swaps_gained"
signal combo_bonus_swaps_gained(swaps_gained : int)
const COMBO_BONUS_CARDS_GAINED : String = "combo_bonus_cards_gained"
signal combo_bonus_cards_gained(num_cards_gained : int)
