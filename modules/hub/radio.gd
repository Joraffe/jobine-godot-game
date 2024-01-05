extends Node


const HUB_STARTED : String = "hub_started"
signal hub_started(hub_data : Dictionary)

const COLLAPSED_DATETIME_CLICKED : String = "collapsed_datetime_clicked"
signal collapsed_datetime_clicked
const MOUSE_ENTERED_EXPANDED_DATETIME : String = "mouse_entered_expanded_datetime"
signal mouse_entered_expanded_datetime
const MOUSE_EXITED_EXPANDED_DATETIME : String = "mouse_exited_expanded_datetime"
signal mouse_exited_expanded_datetime

const BATTLE_SELECTED : String = "battle_selected"
signal battle_selected
