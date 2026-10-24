class_name DealDamageEffect
extends CardEffect

@export var base_amount: int = 1
@export var damage_type: DamageType.Type

func execute(context: CardEffectContext) -> void:
	var damage := DamagePacket.create(base_amount, context.source, context.target, damage_type)
	if context.target:
		DamageHandler.deal_damage(damage)
