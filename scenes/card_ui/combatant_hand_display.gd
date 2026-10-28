extends Control
class_name HandDisplayIcon

#temp
@export var card: Card
@export var owner_combatant: Combatant

@export var sprite: TextureRect

func _ready() -> void:
	sprite.texture = card.card_art
	size = sprite.texture.get_size() * sprite.scale
	custom_minimum_size = size
