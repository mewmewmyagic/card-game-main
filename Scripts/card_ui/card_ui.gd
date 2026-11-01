class_name HandCardUI
extends Control

signal request_snap_back

@export var visuals: CardVisuals

@export var card: Card
@export var owner_combatant: Combatant
var play_manager: CardPlayManager   # set by PlayerHand._spawn_card

@onready var targets: Array[Node] = []
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var animator: CardAnimator = $CardAnimator as CardAnimator

var _hovered: Combatant

var playable: bool = true:
	set(value):
		playable = value
		_update_playable_visuals()
		
func set_interactable(value: bool) -> void:
	playable = value
	
func _update_playable_visuals() -> void:
	modulate = Color.WHITE if playable else Color(0.4, 0.4, 0.4, 1.0)
	
	
func init(p_card: Card, p_owner_combatant: Combatant, p_play_manager: CardPlayManager) -> void:
	card = p_card
	owner_combatant = p_owner_combatant
	play_manager = p_play_manager
	
func _ready() -> void:
	card_state_machine.init(self)
	animator.init(self)
	
	visuals.init(card)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)
	_update_aim()

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	_update_aim()

func _pick_hovered() -> Combatant:
	var best: Combatant = null
	var best_d := INF
	for a in targets:
		if not is_instance_valid(a): continue
		var d := (a as Area2D).global_position.distance_to(get_global_mouse_position())
		if d < best_d:
			best_d = d
			best = a.get_parent() as Combatant
	return best

func _update_aim() -> void:
	var hovered := _pick_hovered()
	if hovered == _hovered:
		return
	_hovered = hovered
	var affected: Array[Combatant] = []
	if hovered and play_manager:
		affected = play_manager.preview_targets(card, owner_combatant, hovered)
	EventBus.card_aim_changed.emit(card, hovered, affected)
