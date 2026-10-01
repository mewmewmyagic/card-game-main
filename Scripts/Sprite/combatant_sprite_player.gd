# combatant_visual.gd
extends AnimatedSprite2D
class_name CombatantSpritePlayer

var _default_animation: String = "idle"

func bind(appearance: CombatantSpriteResource) -> void:
	sprite_frames = appearance.sprite_frames
	_default_animation = appearance.default_animation
	animation_finished.connect(_on_animation_finished)
	play(_default_animation)

func play_animation(anim_name: String) -> void:
	if sprite_frames and sprite_frames.has_animation(anim_name):
		play(anim_name)
	else:
		play(_default_animation)

func _on_animation_finished() -> void:
	if animation == _default_animation:
		return
	if sprite_frames.get_animation_loop(animation):
		return
	play(_default_animation)
