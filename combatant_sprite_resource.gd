# combatant_appearance.gd
class_name CombatantSpriteResource
extends Resource

@export var sprite_frames: SpriteFrames
@export var default_animation: String = "idle"
@export var card_animations: Dictionary = {} #key: card_name, value: animation_name

func get_animation_for_card(card_name: String) -> String:
	return card_animations.get(card_name, default_animation)
