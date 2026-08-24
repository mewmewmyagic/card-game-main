extends Control
class_name CardPileUI

@onready var label: Label  = $CardAmmount
var pile: CardPile
func bind(cardPile: CardPile) -> void:
	pile = cardPile
	pile.card_pile_size_changed.connect(_on_pile_size_changed)
	_refresh()
	
func _on_pile_size_changed(_count: int) -> void:
	_refresh()
	
func _refresh() -> void:
	label.text = str(pile.cards.size())
