class_name DealDamageEffect
extends CardEffect

@export var amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.target:
		amount = context.source.modifer_manager.get_modified_value(amount, Modifier.Type.dmg_dealt)
		context.target.take_damage(amount)
