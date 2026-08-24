class_name CardPlayResolver
extends RefCounted

var battle: BattleState

func can_afford(card: Card, source: Combatant) -> bool:
	return source.stats.can_play_card(card)

func can_play(card: Card, source: Combatant, target: Combatant) -> bool:
	if not source.can_act():
		return false

	return can_afford(card, source)
	
func resolve(card: Card, source: Combatant, target: Combatant) -> bool:
	if not can_play(card, source, target):
		return false
		
	source.stats.stamina -= card.stamina_cost
	
	var context := CardEffectContext.new()
	context.battle = battle
	context.source = source
	context.target_combatant = target
	
	for effect in card.effects:
		effect.execute(context)
	
	source.hand_pile.cards.erase(card)
	source.hand_pile.card_pile_size_changed.emit(source.hand_pile.cards.size())
	source.discard_pile.add_card(card)
	
	battle.turn_manager.end_turn(card.recovery_cost)
	
	
	return true
