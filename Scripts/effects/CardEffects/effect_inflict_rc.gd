class_name EffectInflictRC
extends CardEffect

@export var base_amount: int = 1

func execute(context: CardEffectContext) -> void:
	context.battle_state.add_recovery_time_to_every(context.target, base_amount)
