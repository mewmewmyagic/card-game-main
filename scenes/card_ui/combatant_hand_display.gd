extends Control
class_name HandDisplay

#temp
@export var card: Card
@export var owner_combatant: Combatant

@export var sprite: Sprite2D

func _ready() -> void:
	sprite.texture = card.card_art
