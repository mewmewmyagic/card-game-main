class_name CardPlayManager
extends RefCounted

signal card_resolved(source: Combatant, card: Card)
signal card_rejected(source: Combatant, card: Card)

var battle_state: BattleState


func _on_card_play_requested(card: Card, source: Combatant, target: Combatant) -> void:
	var context := CardEffectContext.create(card, source, target, battle_state)
	resolve(context)


func _on_card_aim_changed(card: Card, source: Combatant, target: Combatant) -> void:
	EventBus.highlight_these_turn_ui.emit(preview_targets(card, source, target))


# --- Validation ---------------------------------------------------------------

func validate_card(context: CardEffectContext) -> bool:
	return can_play(context.card, context.source) and not get_targets(context).is_empty()


func can_play(card: Card, source: Combatant) -> bool:
	return source.is_playing and can_afford(card, source)


func can_afford(card: Card, source: Combatant) -> bool:
	return source.stats.enough_stamina(card.stamina_cost)


## Only relevant for single-target cards. Area cards pick their own targets.
func is_valid_target(context: CardEffectContext) -> bool:
	var target := context.target
	if target == null or target.is_dead:
		return false

	match context.card.target_type:
		Card.TargetType.ENEMY:
			return target in battle_state.opposing_team(context.source)
		Card.TargetType.ALLY:
			return target in battle_state.same_team(context.source)
		Card.TargetType.SELF:
			return target == context.source
		_:
			return false


# --- Targeting ----------------------------------------------------------------

## Returns every combatant the card would hit. Empty means the play is invalid.
func get_targets(context: CardEffectContext) -> Array[Combatant]:
	var result: Array[Combatant] = []
	var source := context.source

	match context.card.target_type:
		Card.TargetType.ALL_ALLY:
			result.append_array(battle_state.alive(battle_state.same_team(source)))
		Card.TargetType.ALL_ENEMY:
			result.append_array(battle_state.alive(battle_state.opposing_team(source)))
		Card.TargetType.ALL:
			result.append_array(battle_state.alive(battle_state.all_combatants()))
		_:
			if is_valid_target(context):
				result.append(context.target)

	return result


func preview_targets(card: Card, source: Combatant, target: Combatant) -> Array[Combatant]:
	var context := CardEffectContext.create(card, source, target, battle_state)
	if not validate_card(context):
		return []
	return get_targets(context)


# --- Resolution ---------------------------------------------------------------

func resolve(context: CardEffectContext) -> void:
	var card := context.card
	var source := context.source

	if not can_play(card, source):
		card_rejected.emit(source, card)
		return

	var targets := get_targets(context)
	if targets.is_empty():
		card_rejected.emit(source, card)
		return

	source.stats.stamina -= card.stamina_cost

	ActionQueue.push_back(AnimationAction.create(source, card))

	for target in targets:
		var effect_context := CardEffectContext.create(card, source, target, battle_state)
		for effect in card.effects:
			ActionQueue.push_back(CardEffectAction.create(effect, effect_context))

	source.card_played.emit(card)
	source.card_piles_handler.after_card_played(card)
	card_resolved.emit(source, card)
