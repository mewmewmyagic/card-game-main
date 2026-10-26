class_name EffectDiscardCard
extends CardEffect

func execute(context: CardEffectContext) -> void:
	context.source.card_piles_handler.discard_pile.add_card(context.card)
