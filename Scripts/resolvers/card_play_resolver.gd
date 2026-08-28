class_name CardPlayResolver
extends RefCounted

var battle: BattleState

func can_afford(card: Card, source: Combatant) -> bool:
	return source.stats.enough_stamina(card)

func can_play(card: Card, source: Combatant, target: Combatant) -> bool:
	if not source.can_act():
		return false

	return can_afford(card, source)
	
	
func _on_player_card_play_requested(card: Card, source: Combatant, target: Combatant) -> void:
	var card_play_context = CardEffectContext.new()
	card_play_context.battle = battle
	card_play_context.source = source
	card_play_context.card = card
	card_play_context.target = target
	resolve(card_play_context)


func resolve(context: CardEffectContext) -> bool:
	if not can_play(context.card, context.source, context.target):
		return false
		
	context.source.stats.stamina -= context.card.stamina_cost
	
	
	for effect in context.card.effects:
		effect.execute(context)
	
	context.source.hand_pile.cards.erase(context.card)
	context.source.hand_pile.card_pile_size_changed.emit(context.source.hand_pile.cards.size())
	context.source.discard_pile.add_card(context.card)
	
	battle.turn_manager.end_turn(context.card.recovery_cost)
	
	
	return true
