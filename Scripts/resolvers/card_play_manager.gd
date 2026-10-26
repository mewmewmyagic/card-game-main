class_name CardPlayManager
extends RefCounted

var battle_state: BattleState
var battle_manager: BattleManager

func _on_player_card_play_requested(card: Card, source: Combatant, target: Combatant) -> void:
	var card_play_context = CardEffectContext.new()
	card_play_context.source = source
	card_play_context.card = card
	card_play_context.target = target
	
	resolve(card_play_context)
	
func validate_card(context: CardEffectContext) -> bool:
	if not can_play(context.card, context.source):
		EventBus.card_play_rejected.emit()
		return false
		
	if not is_valid_target(context):
		EventBus.card_play_rejected.emit()
		return false
		
	return true
	
func get_targets(context: CardEffectContext) -> Array[Combatant]:
	var result: Array[Combatant] = []
	match context.card.target_type:
		Card.TargetType.ALL_ENEMY:
			result.append_array(battle_state.alive(battle_state.opposing_team(context.source)))
		Card.TargetType.ALL:
			result.append_array(battle_state.alive(battle_state.all_combatants()))
		_:
			if context.target != null:
				result.append(context.target)
	return result
	
func resolve(context: CardEffectContext) -> void:
	if not validate_card(context):
		return
	
	var targets := get_targets(context)
	context.source.stats.stamina -= context.card.stamina_cost
	
	ActionQueue.push_back(AnimationAction.create(context.source, context.card))
	
	for t in targets:
		for effect in context.card.effects:
			ActionQueue.push_back(CardEffectAction.create(effect, _context_for(context, t)))
	
	context.source.card_played.emit(context.card)
	
	context.source.card_piles_handler.after_card_played(context.card)

	#TODO dont depend on battle_manager
	battle_manager.turn_manager._add_recovery_cost(context.card.recovery_cost)
	battle_manager.output_phase()
	
func _context_for(context: CardEffectContext, target: Combatant) -> CardEffectContext:
	var c := CardEffectContext.new()
	c.card = context.card
	c.source = context.source
	c.target = target
	return c
	
func can_afford(card: Card, source: Combatant) -> bool:
	return source.stats.enough_stamina(card)

func can_play(card: Card, source: Combatant) -> bool:
	if not source.is_playing:
		return false

	return can_afford(card, source)
	
func is_valid_target(context: CardEffectContext) -> bool:
	if context.target == null or context.target.is_dead:
		return false
	
	match context.card.target_type:
		Card.TargetType.ENEMY, Card.TargetType.ALL_ENEMY:
			return context.target in battle_state.opposing_team(context.source)
		Card.TargetType.ALLY, Card.TargetType.ALL_ALLY:
			return context.target in battle_state.same_team(context.source)
		Card.TargetType.SELF:
			return context.target == context.source
		_:
			return false
