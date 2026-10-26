class_name EffectExhaustCard
extends CardEffect

func execute(context: CardEffectContext) -> void:
	context.source.card_piles_handler.exhaust_pile.add_card(context.card)
