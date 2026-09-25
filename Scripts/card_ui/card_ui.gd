class_name CardUI
extends Control

signal request_snap_back

#TODO change this later
@onready var color: ColorRect = $Visuals/Color
@onready var stam_label: Label = $Visuals/Stam
@onready var rc_label: Label = $Visuals/Rc
@onready var name_label: Label = $Visuals/Name
@onready var visuals: Node = $Visuals

#temp
@export var card: Card
@export var owner_combatant: Combatant

@onready var targets: Array[Node] = []
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var animator: CardAnimator = $CardAnimator as CardAnimator

var playable: bool = true:
	set(value):
		playable = value
		_update_playable_visuals()
		
func set_interactable_ui(value: bool) -> void:
	playable = value
	
func _update_playable_visuals() -> void:
	modulate = Color.WHITE if playable else Color(0.4, 0.4, 0.4, 1.0)
	
func _ready() -> void:
	card_state_machine.init(self)
	animator.init(self)
	
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
		
func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
