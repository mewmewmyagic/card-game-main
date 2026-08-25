class_name DealDamageEffect
extends CardEffect

@export var amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.target:
		context.target.take_damage(amount)
