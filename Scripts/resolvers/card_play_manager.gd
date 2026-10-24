class_name CardPlayManager
extends RefCounted

var battle: BattleManager

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
	
func resolve(context: CardEffectContext) -> void:
	if not validate_card(context):
		return
	
	context.source.stats.stamina -= context.card.stamina_cost
	
	ActionQueue.push_back(AnimationAction.create(context.source, context.card))
	
	for effect in context.card.effects:
		ActionQueue.push_back(CardEffectAction.create(effect, context))
	
	context.source.card_played.emit(context.card)
	
	context.source.hand_pile.remove_card(context.card)
	context.source.discard_pile.add_card(context.card)
	
	battle.turn_manager._add_recovery_cost(context.card.recovery_cost)
	
	battle.output_phase()
	
	
func can_afford(card: Card, source: Combatant) -> bool:
	return source.stats.enough_stamina(card)

func can_play(card: Card, source: Combatant) -> bool:
	if not source.is_playing:
		return false

	return can_afford(card, source)
	
func is_valid_target(context: CardEffectContext) -> bool:
	if context.target == null:
		return false
	if context.target.is_dead:
		return false
	
	match context.card.target_type:
		Card.TargetType.ENEMY:
			return context.target in battle.opposing_team(context.source)
		Card.TargetType.ALLY:
			return context.target in battle.same_team(context.source)
		Card.TargetType.SELF:
			return context.target == context.source
		_:
			return false
