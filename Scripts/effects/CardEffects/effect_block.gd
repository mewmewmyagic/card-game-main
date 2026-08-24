class_name GainShieldEffect
extends CardEffect

@export var amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.source:
		context.source.gain_shield(amount)
