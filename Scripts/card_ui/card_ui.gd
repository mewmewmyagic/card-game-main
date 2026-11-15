class_name HandCardUI
extends Control

@export var visuals: CardVisuals

@export var card: Card
@export var owner_combatant: Combatant
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var animator: CardAnimator = $CardAnimator as CardAnimator

var target: Combatant = null
var position_in_hand: Vector2
var rotation_in_hand: float

var playable: bool = true:
	set(value):
		playable = value
		_update_playable_visuals()
		
func set_interactable(value: bool) -> void:
	playable = value
	
func _update_playable_visuals() -> void:
	modulate = Color.WHITE if playable else Color(0.4, 0.4, 0.4, 1.0)
	
	
func init(p_card: Card, p_owner_combatant: Combatant) -> void:
	card = p_card
	owner_combatant = p_owner_combatant
	
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
	if target != null:
		return # one target at a time, first one wins
	target = area.get_parent() as Combatant
	_update_aim()

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	if area.get_parent() != target:
		return
	target = null
	# still over something else? pick it up instead of dropping to null
	for a in drop_point_detector.get_overlapping_areas():
		if a != area:
			target = a.get_parent() as Combatant
			break
	_update_aim()

func _update_aim() -> void:
	EventBus.card_aim_changed.emit(card, owner_combatant, target) # used by card_play_manager
