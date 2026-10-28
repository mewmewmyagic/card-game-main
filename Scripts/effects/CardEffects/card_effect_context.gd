class_name CardEffectContext
extends RefCounted

var card: Card
var source: Combatant
var target: Combatant
var battle_state: BattleState


static func create(c: Card, s: Combatant, t: Combatant, b: BattleState) -> CardEffectContext:
	var ctx := CardEffectContext.new()
	ctx.card = c 
	ctx.source = s
	ctx.target = t
	ctx.battle_state = b
	return ctx
