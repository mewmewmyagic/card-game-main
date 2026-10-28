class_name CardEffectContext
extends RefCounted

var card: Card
var source: Combatant
var target: Combatant


static func create(c: Card, s: Combatant, t: Combatant) -> CardEffectContext:
	var ctx := CardEffectContext.new()
	ctx.card = c 
	ctx.source = s
	ctx.target = t
	return ctx
