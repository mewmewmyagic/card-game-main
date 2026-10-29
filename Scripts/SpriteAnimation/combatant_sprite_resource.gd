class_name CombatantSpriteResource
extends Resource

@export var sprite_frames: SpriteFrames
@export var combatant_icon: Texture2D

var idle_animation: String = "idle"

func get_animation_for_card(card: Card) -> StringName:
	if card != null:
		var type_name: String = Card.CardType.keys()[card.card_type].to_lower()
		
		if has_animation(StringName(card.card_name.to_lower())):
			return StringName(card.card_name.to_lower())
		if has_animation(StringName("default_" + type_name)):
			return StringName("default_" + type_name)
			
	return StringName(idle_animation)

func has_animation(anim: StringName) -> bool:
	if sprite_frames != null and sprite_frames.has_animation(anim):
		return true
	return false
