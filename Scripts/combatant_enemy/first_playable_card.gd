# FirstPlayableCardBehavior.gd
class_name FirstPlayableCardBehavior
extends EnemyAIBehavior

func choose_card(enemy: Combatant, battle: BattleManager) -> Card:
	for card in enemy.card_piles_handler.hand_pile.cards:
		if battle.card_play_manager.can_play(card, enemy):
			return card
	print("cant do shit")
	
	battle.turn_manager.end_turn()
	return null
