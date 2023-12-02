extends Area2D


@onready var battle_arena : Node2D = get_parent()


#=======================
# Godot Lifecycle Hooks
#=======================
func _ready() -> void:
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	BattleRadio.connect(BattleRadio.CARD_SELECTED, _on_card_selected)
	BattleRadio.connect(BattleRadio.CARD_DESELECTED, _on_card_deselected)


#========================
# Signal Handlers
#========================
func _on_mouse_entered() -> void:
	if not battle_arena.data.is_card_selected:
		return

	BattleRadio.emit_signal(BattleRadio.CARD_TARGETING_ENABLED)

func _on_mouse_exited() -> void:
	if not battle_arena.data.is_card_selected:
		return

	BattleRadio.emit_signal(BattleRadio.CARD_TARGETING_DISABLED)

func _on_card_selected(_card : Card) -> void:
	battle_arena.data = BattleArenaData.new({
		BattleArenaData.IS_CARD_SELECTED: true 
	})

func _on_card_deselected(_card : Card) -> void:
	battle_arena.data = BattleArenaData.new({
		BattleArenaData.IS_CARD_SELECTED: false 
	})
