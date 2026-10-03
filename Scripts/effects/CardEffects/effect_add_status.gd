class_name EffectAddStatus
extends CardEffect

@export var status: StatusEffect
@export var stack: int
@export var count: int

func execute(context: CardEffectContext) -> void:
	if context.battle:
		context.target.status_manager.apply_status(status, stack, count)
