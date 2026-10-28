# FirstPlayableCardBehavior.gd
class_name RandomAIBehavior
extends CombatantAIBase

func choose_card(user: Combatant, battle: BattleManager) -> Card:
	var playable: Array[Card] = []
	for card in user.card_piles_handler.hand_pile.cards:
		if battle.card_play_manager.can_play(card, user):
			playable.append(card)
	
	if not playable.is_empty():
		return playable.pick_random()
	else:
		push_error("No cards found")
		return null

func choose_target(enemy: Combatant, battle: BattleManager) -> Combatant:
	
	var targets := battle.battle_state.opposing_team(enemy).filter(func(c): return not c.is_dead)
	if targets.is_empty():
		push_error("No targets found")
		return null
	return targets.pick_random()  # override for smarter targeting
