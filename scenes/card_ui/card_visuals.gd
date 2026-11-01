extends Control
class_name CardVisuals

@export var stam_label: Label
@export var rc_label: Label
@export var name_label: Label
@export var card_art: TextureRect

func init(card: Card) -> void:
	stam_label.text = "%s" % [card.stamina_cost]
	rc_label.text = "%s" % [card.recovery_cost]
	name_label.text = "%s" % [card.card_name]
	card_art.texture = card.card_art
