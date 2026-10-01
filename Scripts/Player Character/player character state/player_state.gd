class_name PlayerState
extends Node

enum State {IDLE, WALK, RUN}
signal transition_requested(from: PlayerState, to: State)

@export var state: State
var player: PlayerCharacter

func enter() -> void:
	pass
func exit() -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
	
func on_input (_event: InputEvent) -> void:
	pass
