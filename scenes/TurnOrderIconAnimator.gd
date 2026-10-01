# CardAnimator.gd
class_name TurnOrderIconAnimator
extends Node

@export var move_duration: float = 0.2
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

var turn_icon: Control
var _active_tween: Tween
var is_animating: bool = false

func init(icon: Control) -> void:
	turn_icon = icon

func move_to(target_position: Vector2, target_rotation: float = 0.0 , duration: float = -1.0, scale: float = 1.0) -> void:
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	is_animating = true
	var d := duration if duration > 0.0 else move_duration
	
	_active_tween = turn_icon.create_tween()
	_active_tween.set_trans(trans_type)
	_active_tween.set_ease(ease_type)
	_active_tween.tween_property(turn_icon, "position", target_position, d)
	_active_tween.parallel().tween_property(turn_icon, "rotation_degrees", target_rotation, d)
	_active_tween.parallel().tween_property(turn_icon, "scale", Vector2(scale, scale), d)
	_active_tween.finished.connect(func(): is_animating = false)
