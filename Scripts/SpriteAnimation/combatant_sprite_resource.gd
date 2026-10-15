class_name CombatantSpriteResource
extends Resource

@export var sprite_frames: SpriteFrames
@export var combatant_icon: Texture2D

var idle_animation: String = "idle" #hopefully never happens

func get_animation_for_card(card: Card) -> StringName:
	if card != null:
		var type_name: String = Card.TargetType.keys()[card.target_type].to_lower()
		for anim in [
			StringName(card.card_name),                           
			StringName("default_" + type_name),                   
		]:
			if is_usable(anim):
				return anim

	return StringName(idle_animation)

func is_usable(anim: StringName) -> bool:
	if sprite_frames != null and sprite_frames.has_animation(anim):
		return true
	return false
