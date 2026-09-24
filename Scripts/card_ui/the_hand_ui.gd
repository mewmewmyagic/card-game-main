extends Control
class_name TheHand

## Base spacing between cards divided down from a reference value
const CARD_SPACING: float = 110
## Width of the play area, used to center the hand horizontally
const LAYOUT_WIDTH: float = 1152.0
## Max vertical arc height applied to the outermost cards
const ARC_RADIUS: float = 600.0
## Rotation applied per card index, creating the fan effect
const ROTATION_PER_CARD: float = 2.5
## Vertical offset subtracted so cards sit slightly above the anchor point
const CARD_Y_OFFSET: float = 10.0
const LAYOUT_TWEEN_DURATION: float = 0.5


@export var card_ui_scene: PackedScene
var cards: Array[CardUI] = []
var card_to_ui: Dictionary = {}
var hand_pile: CardPile
var card_play_manager: CardPlayManager
var source_combatant: Combatant

func bind(resolver: CardPlayManager, source: Combatant) -> void:
	#dont bind if already binded
	if source == source_combatant:
		return
		
	_unbind()
	
	hand_pile = source.hand_pile
	card_play_manager = resolver
	source_combatant = source
	hand_pile.card_pile_size_changed.connect(_on_pile_changed)
	source_combatant.stats.stamina_changed.connect(_on_stamina_changed)
	
	_sync()
	_update_interactability_ui()
	
func _unbind() -> void:
	if hand_pile and hand_pile.card_pile_size_changed.is_connected(_on_pile_changed):
		hand_pile.card_pile_size_changed.disconnect(_on_pile_changed)
	if source_combatant and source_combatant.stats.stamina_changed.is_connected(_on_stamina_changed):
		source_combatant.stats.stamina_changed.disconnect(_on_stamina_changed)
	
	source_combatant = null
	for card in card_to_ui.keys().duplicate():
		_despawn_card(card)

func _on_stamina_changed(_new_stamina: int) -> void:
	_update_interactability_ui()

func _update_interactability_ui() -> void:
	for card_ui in card_to_ui.values():
		var playable := card_play_manager.can_play(card_ui.card, source_combatant)
		card_ui.set_interactable_ui(playable)

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
	card_ui.owner_combatant = source_combatant
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
	
	var spacing: float = CARD_SPACING * 1/count
	if count > 1:
		spacing = min(CARD_SPACING, LAYOUT_WIDTH / (count - 1))
	
	var center_x := LAYOUT_WIDTH / 2.0
	var total_width := (count - 1) * spacing
	var center_index: float = (float(count) - 1.0) / 2.0
	
	for i in count:
		var card := cards[i]
		
		var target_rotation := (i - count / 2.0) * ROTATION_PER_CARD
		
		var x := center_x + (i * spacing - total_width / 2.0)
		var normalized_offset: float = 0.0
		
		var theta: float = deg_to_rad(target_rotation)
		var y: float = (ARC_RADIUS - ARC_RADIUS * cos(theta)) * 4
		var target_position := Vector2(x, y) - Vector2(card.size.x, CARD_Y_OFFSET * count/3) / 2.0

		_animate_card(card, target_position, target_rotation)

func _animate_card(card: CardUI, target_position: Vector2, target_rotation: float) -> void:
	card.animator.move_to(target_position, target_rotation, LAYOUT_TWEEN_DURATION)
