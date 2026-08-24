class_name EffectDrawCard
extends CardEffect

@export var amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.battle:
		context.source.draw_to_hand()
