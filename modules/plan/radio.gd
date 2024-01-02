extends Node


const PLAN_STARTED : String = "plan_started"
signal plan_started(seed_data : Dictionary)

const ROSTER_MEMBER_SELECTED : String = "roster_member_selected"
signal roster_member_selected(character_name : String, role : String)
const ROSTER_MEMBER_DESELECTED : String = "roster_member_deselected"
signal roster_member_deselected(character_name : String, role : String)

const PARTY_UPDATED : String = "party_updated"
signal party_updated(party_data : Dictionary)

const PARTY_FILLED : String = "party_filled"
signal party_filled
const PARTY_UNFILLED : String = "party_unfilled"
signal party_unfilled

const DECK_UPDATED : String = "deck_updated"
signal deck_updated(deck_data : Dictionary)

const PLAN_CONFIRMED : String = "plan_confirmed"
signal plan_confirmed
