extends Node

 
# Overall Battle Related
const BATTLE_STARTED : String = "battle_started"
signal battle_started(battle_data : BattleData)


# BattleArena Related
const CARD_TARGETING_ENABLED : String = "card_targeting_enabled"
signal card_targeting_enabled
const CARD_TARGETING_DISABLED : String = "card_targeting_disabled"
signal card_targeting_disabled


# Deck Related
const CARD_DRAWN : String = "card_drawn"
signal card_drawn(card : Card)
const CARDS_DRAWN : String = "cards_drawn"
signal cards_drawn(cards : Array[Card])
const DECK_EMPTIED : String = "deck_emptied"
signal deck_emptied


# Discard Related
const DISCARD_PILE_SHUFFLED_INTO_DECK : String = "discard_pile_shuffled_into_deck"
signal discard_pile_shuffled_into_deck(discard_pile : Array[Card])


# Hand Related
const CURRENT_HAND_SIZE_UPDATED : String = "current_hand_size_updated"
signal current_hand_size_updated(current_hand_size_updated : int)


# Swap Related
const CURRENT_SWAPS_UPDATED : String = "current_swaps_updated"
signal current_swaps_updated(current_swaps : int)
const CURRENT_LEAD_UPDATED : String = "current_lead_updated"
signal current_lead_updated(current_lead_instance_id : int)


# Enemy Related
const ENEMY_TARGET_SELECTED : String = "enemy_target_selected"
signal enemy_target_selected(enemy : Enemy)
const ENEMY_DEFEATED_ANIMATION_QUEUED : String = "enemy_defeated_animation_queued"
signal enemy_defeated_animation_queued(instance_id : int)
const ENEMY_DEFEATED_ANIMATION_FINISHED : String = "enemy_defeated_animation_finished"
signal enemy_defeated_animation_finished(instance_id : int)


# Card Related
const CARD_SELECTED : String = "card_selected"
signal card_selected(card : Card)
const CARD_DESELECTED : String = "card_deselected"
signal card_deselected(card : Card)
const CARD_PLAYED : String = "card_played"
signal card_played(card : Card)
const CARD_DISCARDED : String = "card_discarded"
signal card_discarded(card : Card)
const CARD_FREED : String = "card_freed"
signal card_freed(card : Card)


# Turn Related
const PLAYER_TURN_STARTED : String = "player_turn_started"
signal player_turn_started
const PLAYER_TURN_ENDED : String = "player_turn_ended"
signal player_turn_ended
const ENEMY_TURN_STARTED : String = "enemy_turn_started"
signal enemy_turn_started
const ENEMY_TURN_ENDED : String = "enemy_turn_ended"
signal enemy_turn_ended


# Energy Related
const CURRENT_ENERGY_UPDATED : String = "current_energy_updated"
signal current_energy_updated(current_energy : int)


# Elements Related
const ELEMENTS_SETTLED : String = "elements_settled"
signal elements_settled(instance_id : int)


# Faint Related
const FAINT_SETTLED : String = "faint_settled"
signal faint_settled(instance_id : int)


# Entity Related
const ELEMENTS_REMOVED_FROM_ENTITY : String = "elements_removed_from_entity"
signal elements_removed_from_entity(
	instance_id : int,
	removed_element_indexes : Array[int]
)
const ENTITY_FAINED : String = "entity_fainted"
signal entity_fainted(instance_id : int)
const ENTITY_DEFEATED_ANIMATION_QUEUED : String = "entity_defeated_animation_queued"
signal entity_defeated_animation_queued(instance_id : int)
const ENTITY_DEFEATED_ANIMATION_FINISHED : String = "entity_defeated_animation_finished"
signal entity_defeated_animation_finished(instance_id : int)


# Enemy Attack Related
const ENEMY_ATTACK_ANIMATION_QUEUED : String = "enemy_attack_animation_queued"
signal enemy_attack_animation_queued(enemy_instance_id : int, attack : EnemyAttack)
const ENEMY_ATTACK_ANIMATION_FINISHED : String = "enemy_attack_animation_finished"
signal enemy_attack_animation_finished


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


# Combo Related
const COMBO_ANIMATION_QUEUED : String = "combo_animation_queued"
signal combo_animation_queued(instance_id : int, combo : Combo)
const COMBO_ANIMATION_FINISHED : String = "combo_animation_finished"
signal combo_animation_finished(instance_id : int)


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
signal combo_effects_deferred_to_group(
	group_name : String, 
	combiner : Combiner,
	combo_target_instance_id : int
)
const COMBO_CHECK_DEFERRED : String = "combo_check_deferred"
signal combo_check_deferred(instance_id : int)
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
