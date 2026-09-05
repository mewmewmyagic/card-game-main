class_name AddCardEffect
extends CardEffect

@export var amount: int = 1
@export var card: Card
func execute(context: CardEffectContext) -> void:
	for i in amount:
		context.target.add_to_hand(card.duplicate())
