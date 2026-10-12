extends AnimatedSprite2D
class_name CombatantSpritePlayer

var _idle_animation: String = "idle"
var _default_attack_animation: String = "attack"

func bind(appearance: CombatantSpriteResource) -> void:
	sprite_frames = appearance.sprite_frames
	_idle_animation = appearance.idle_animation
	
	animation_finished.connect(_on_animation_finished)
	play(_idle_animation)

func play_card_animation(anim_name: String, anim_type: Card.TargetType = Card.TargetType.ENEMY) -> void:
	if sprite_frames and sprite_frames.has_animation(anim_name):
		play(anim_name)
	else:
		print("no sprite frame or animation")

func _on_animation_finished() -> void:
	if animation == _idle_animation:
		return
	if sprite_frames.get_animation_loop(animation):
		return
	play(_idle_animation)
