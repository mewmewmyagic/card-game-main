# CardAnimator.gd
class_name CardAnimator
extends Node

@export var move_duration: float = 0.2
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

var card_ui: Control  # set by CardUI on _ready, same pattern as CardStateMachine.init
var _active_tween: Tween
var is_animating: bool = false

func init(card: Control) -> void:
	card_ui = card

func move_to(target_position: Vector2, target_rotation: float, duration: float = -1.0) -> void:
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	is_animating = true
	var d := duration if duration > 0.0 else move_duration
	_active_tween = card_ui.create_tween()
	_active_tween.set_trans(trans_type)
	_active_tween.set_ease(ease_type)
	_active_tween.tween_property(card_ui, "position", target_position, d)
	_active_tween.parallel().tween_property(card_ui, "rotation_degrees", target_rotation, d)
	_active_tween.finished.connect(func(): is_animating = false)
	
func despawn() -> void:
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	var tween := card_ui.create_tween()
	tween.tween_property(card_ui, "modulate:a", 0.0, 0.15)
	tween.tween_property(card_ui, "scale", Vector2(0.8, 0.8), 0.15)
	await tween.finished
