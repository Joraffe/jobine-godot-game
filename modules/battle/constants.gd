extends Resource
class_name BattleConstants

const INSTANCE_ID : String = "instance_id"
const TARGET_INSTANCE_ID : String = "target_instance_id"
const EFFECTOR_INSTANCE_ID : String = "effector_instance_id"

const ENTITY_CHARACTER : String = "entity_character"
const ENTITY_ENEMY : String = "entity_enemy"
const ENTITY_BOSS : String = "entity_boss"

const GROUP_PARTY : String = "group_party"
const GROUP_ENEMIES : String = "enemies"

const STANDBY_TOP_POSITION : String = "standby_top_position"
const STANDBY_BOTTOM_POSITION : String = "standby_bottom_position"

const EFFECT_TYPE : String = "effect_type"
const DAMAGE_EFFECT : String = "damage_effect"
const STATUS_EFFECT : String = "status_effect"
const ADD_STATUS_EFFECT : String = "add_status_effect"
const REMOVE_STATUS_EFFECT : String = "remove_status_effect"
const STATUS_CARD_EFFECT : String = "status_card_effect"
const ELEMENT_EFFECT : String = "element_effect"

const EFFECT_NAME : String = "effect_name"
const EFFECT_AMOUNT : String = "effect_amount"
const EFFECT_RESULT : String = "effect_result"

const FAINTED : String = "fainted"
const DAMAGED : String = "damaged"
const ADDED_ELEMENTS : String = "added_elements"
const ADDED_STATUS : String = "added_status"
const REMOVED_STATUS : String = "removed_status"

const SHOULD_BAIL : String = "should_bail"

const SKIP_FROZEN : String = "skip_frozen"
const REMOVE_FROZEN : String = "remove_frozen"


# non-BattleRadio shared signal names
const STATUS_EFFECT_DURATION_UPDATED : String = "status_effect_duration_updated"
const NEW_STATUS_EFFECT_ADDED : String = "new_status_effect_added"
const NEW_STATUS_EFFECT_NOT_ADDED : String = "new_status_effect_not_added"
const NEW_STATUS_EFFECT_DISPLAYED : String = "new_status_effect_displayed"
const STATUS_EFFECTS_REMOVED : String = "status_effects_removed"
const STATUS_EFFECTS_REMAINED : String = "status_effects_remained"
