extends CenterContainer


@export var visual: CardVisuals
var card: Card

func init(p_card: Card) -> void:
	card = p_card
	visual.init(card)
