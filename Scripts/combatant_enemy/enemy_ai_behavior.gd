# EnemyAIBehavior.gd
class_name EnemyAIBehavior
extends Resource

func choose_card(enemy: Combatant, battle: BattleState) -> Card:
	return null  # override

func choose_target(enemy: Combatant, battle: BattleState) -> Combatant:
	return battle.player  # override
