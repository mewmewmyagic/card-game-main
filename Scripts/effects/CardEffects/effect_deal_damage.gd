class_name DealDamageEffect
extends CardEffect

@export var base_amount: int = 1

func execute(context: CardEffectContext) -> void:
	if context.target:
		var amount := context.source.modifier_manager.get_modified_value(base_amount, Modifier.Type.dmg_dealt)
		context.target.take_damage(amount)
