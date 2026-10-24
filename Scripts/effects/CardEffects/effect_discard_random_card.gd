class_name EffectDiscardRandomCard
extends CardEffect

@export var amount: int = 1


func execute(context: CardEffectContext) -> void:
	var hand_pile := context.target.hand_pile
	var discard_pile := context.target.discard_pile

	for i in amount:
		if hand_pile.cards.is_empty():
			return
		var card: Card = hand_pile.cards.pick_random()
		hand_pile.remove_card(card)
		discard_pile.add_card(card)
