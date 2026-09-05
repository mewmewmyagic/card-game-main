extends Control
class_name CardPileUI

@onready var label: Label  = $CardAmmount
var pile: CardPile

func bind(cardPile: CardPile) -> void:
	unbind()
	pile = cardPile
	pile.card_pile_size_changed.connect(_on_pile_size_changed)
	_refresh()
	
func unbind() -> void:
	if pile and pile.card_pile_size_changed.is_connected(_on_pile_size_changed):
		pile.card_pile_size_changed.disconnect(_on_pile_size_changed)
	pile = null
	
func _on_pile_size_changed(_count: int) -> void:
	_refresh()
	
func _refresh() -> void:
	if pile == null:
		print("card pile null in pile ui")
		return
	label.text = str(pile.cards.size())
