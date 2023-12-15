extends Node2D


var discard_pile : Array[Card] :
	set = set_discard_pile
var discard_pile_count : int :
	set = set_discard_pile_count
var num_freed : int :
	set = set_num_freed

var image_data : ImageData = ImageData.new(
	"battle_field_discard",
	"empty",
	"discard.png"
)
var discard_card_scene = preload("res://scenes/battle_field_discard_card/BattleFieldDiscardCard.tscn")


var discard_queue : Queue = Queue.new()
var free_queue : Queue = Queue.new()


#=======================
# Godot Lifecycle Hooks
#=======================
func _init() -> void:
	BattleRadio.connect(BattleRadio.BATTLE_STARTED, _on_battle_started)
	BattleRadio.connect(BattleRadio.CARD_PLAYED, _on_card_played)
	BattleRadio.connect(BattleRadio.CARD_DISCARDED, _on_card_discarded)
	BattleRadio.connect(BattleRadio.DECK_EMPTIED, _on_deck_emptied)

func _ready() -> void:
	$DiscardReshuffleTimer.connect("timeout", _on_discard_reshuffle_delay_finished)


#=======================
# Setters
#=======================
func set_discard_pile(new_discard_pile : Array[Card]) -> void:
	discard_pile = new_discard_pile
	self.set("discard_pile_count", self.discard_pile.size())

func set_discard_pile_count(new_count : int) -> void:
	discard_pile_count = new_count
	$Area2D/Sprite2D/Panel/Label.update_discard_pile_number(discard_pile_count)

func set_num_freed(new_num_freed : int) -> void:
	num_freed = new_num_freed

	if self.num_freed == self.discard_pile.size():
		var empty : Array[Card] = []
		self.set("discard_pile", empty)
		BattleRadio.emit_signal(BattleRadio.DISCARD_PILE_SHUFFLED_INTO_DECK)
	else:
		self.set("discard_pile_count", self.discard_pile.size() - self.num_freed)
		$DiscardReshuffleTimer.start()


#========================
# Signal Handlers
#========================
func _on_battle_started(battle_data : BattleData) -> void:
	self.set("discard_pile", battle_data.discard_pile)

func _on_card_played(played_card : Card, _targeting : Targeting) -> void:
	self.add_card_to_discard_pile(played_card)

func _on_card_discarded(discarded_card : Card) -> void:
	self.add_card_to_discard_pile(discarded_card)

func _on_discard_reshuffle_delay_finished() -> void:
	self.animate_discard_reshuffle()

func _on_deck_emptied() -> void:
	self.kickoff_reshuffle_discard_pile()


#============================
# Discard Pile Functionality
#============================
func add_card_to_discard_pile(card : Card) -> void:
	self.discard_pile.append(card)
	self.set("discard_pile_count", self.discard_pile_count + 1)

func animate_discard_reshuffle():
	var discard_card_instance = self.discard_queue.dequeue()
	self.free_queue.enqueue(discard_card_instance)
	var tween = self.create_tween()
	tween.parallel().tween_property(
		discard_card_instance,
		"position",
		Vector2(100, 100),
		0.1
	).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(
		discard_card_instance,
		"scale",
		Vector2(1, 1),
		0.1
	)
	tween.tween_callback(self.increment_counter_and_free_card)

func kickoff_reshuffle_discard_pile():
	for _i in self.discard_pile.size():
		var discard_card_instance = discard_card_scene.instantiate()
		discard_card_instance.scale = Vector2(0, 0)
		self.discard_queue.enqueue(discard_card_instance)
		self.add_child(discard_card_instance)
	self.set("num_freed", 0)

func increment_counter_and_free_card() -> void:
	var discard_instance : Node2D = self.free_queue.dequeue()
	discard_instance.queue_free()
	self.set("num_freed", self.num_freed + 1)
