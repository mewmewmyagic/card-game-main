class_name EffectAddTurn
extends CardEffect


func execute(context: CardEffectContext) -> void:
	if context.battle:
		context.battle.turn_manager.round_order.push_front(context.source)
