class_name EffectInflictRC
extends CardEffect

@export var base_amount: int = 1

func execute(context: CardEffectContext) -> void:
	context.target.stats.add_recovery_time_to_all(base_amount)
