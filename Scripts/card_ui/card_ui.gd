class_name CardUI
extends Control

# Called when the node enters the scene tree for the first time.

#TODO change this later
@onready var color: ColorRect = $Visuals/Color
@onready var state: Label = $Visuals/State
@onready var visuals: Node = $Visuals

#temp
@export var card: Card

@onready var targets: Array[Node] = []
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var animator: CardAnimator = $CardAnimator as CardAnimator

var playable: bool = true:
	set(value):
		playable = value
		_update_playable_visuals()
		
func set_playable(value: bool) -> void:
	playable = value
	
func _update_playable_visuals() -> void:
	modulate = Color.WHITE if playable else Color(1,1,1,0.4)
	
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
	
