extends BattleAction
class_name CardEffectAction

var effect: CardEffect
var context: CardEffectContext

static func create(p_effect: CardEffect, p_context: CardEffectContext) -> CardEffectAction:
	var action := CardEffectAction.new()
	action.effect = p_effect
	action.context = p_context
	return action

func execute() -> void:
	await effect.execute(context)
