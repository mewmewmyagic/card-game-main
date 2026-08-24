extends Control
class_name TheHand

## Base spacing between cards divided down from a reference value
const CARD_SPACING: float = 110
## Width of the play area, used to center the hand horizontally
const LAYOUT_WIDTH: float = 1152.0
## Max vertical arc height applied to the outermost cards
const ARC_HEIGHT: float = 25.0
## Rotation applied per card index, creating the fan effect
const ROTATION_PER_CARD: float = 2.0
## Vertical offset subtracted so cards sit slightly above the anchor point
const CARD_Y_OFFSET: float = 10.0
const LAYOUT_TWEEN_DURATION: float = 0.5

@export var card_ui_scene: PackedScene
var cards: Array[CardUI] = []
var card_to_ui: Dictionary = {}
var hand_pile: CardPile
var card_play_resolver: CardPlayResolver
var source_combatant: Combatant

func bind(pile: CardPile, resolver: CardPlayResolver, source: Combatant) -> void:
	hand_pile = pile
	card_play_resolver = resolver
	source_combatant = source
	hand_pile.card_pile_size_changed.connect(_on_pile_changed)
	source.stats.stamina_changed.connect(_on_stamina_changed)
	#print(hand_pile.cards.size())
	_sync()

func _on_stamina_changed(_new_stamina: int) -> void:
	_update_playability_ui()

func _update_playability_ui() -> void:
	for card_ui in card_to_ui.values():
		var playable := card_play_resolver.can_play(card_ui.card, source_combatant, null)
		card_ui.set_playable(playable)

func _on_pile_changed(_count: int) -> void:
	_sync()

func _sync() -> void:
	for card in hand_pile.cards:
		if not card_to_ui.has(card):
			_spawn_card(card)
	
	for card in card_to_ui.keys().duplicate():
		if not hand_pile.cards.has(card):
			_despawn_card(card)
	
	_refresh_cards()
	_update_layout()

func _spawn_card(card: Card) -> void:
	var card_ui := card_ui_scene.instantiate() as CardUI
	card_ui.card = card
	add_child(card_ui)
	card_to_ui[card] = card_ui

func _despawn_card(card: Card) -> void:
	var card_ui: CardUI = card_to_ui[card]
	card_to_ui.erase(card)
	card_ui.queue_free()

func _refresh_cards() -> void:
	cards.clear()
	for card_ui in card_to_ui.values():
		cards.append(card_ui)

func request_relayout() -> void:
	_update_layout()
	
func update() -> void:
	_refresh_cards()
	_update_layout()

func _update_layout() -> void:
	var count := cards.size()
	if count == 0:
		return
	var center_x := LAYOUT_WIDTH / 2.0
	var total_width := (count - 1) * CARD_SPACING
	var center_index: float = (float(count) - 1.0) / 2.0
	for i in count:
		var card := cards[i]
		var x := center_x + (i * CARD_SPACING - total_width / 2.0)
		var normalized_offset: float = 0.0
		if center_index != 0.0:
			normalized_offset = (i - center_index) / center_index
		var y: float = normalized_offset * normalized_offset * ARC_HEIGHT
		var target_position := Vector2(x, y) - Vector2(card.size.x, CARD_Y_OFFSET) / 2.0
		var target_rotation := int(i - count / 2.0) * ROTATION_PER_CARD
		#if card.card_state_machine.current_state.state != CardState.State.BASE:
			#continue
		_animate_card(card, target_position, target_rotation)
# Hands.gd — replaces the old _animate_card body entirely
func _animate_card(card: CardUI, target_position: Vector2, target_rotation: float) -> void:
	card.animator.move_to(target_position, target_rotation, LAYOUT_TWEEN_DURATION)	
