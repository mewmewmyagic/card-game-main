# FirstPlayableCardBehavior.gd
class_name FirstPlayableCardBehavior
extends EnemyAIBehavior

func choose_card(enemy: Combatant, battle: BattleState) -> Card:
	for card in enemy.hand_pile.cards:
		if battle.card_play_resolver.can_play(card, enemy, null):
			return card
	print("cant do shit")
	return null
