class_name DealDamageEffect
extends CardEffect

@export var amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.target_combatant:
		context.target_combatant.take_damage(amount)
