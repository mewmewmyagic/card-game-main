# EnemyAIBehavior.gd
class_name EnemyAIBehavior
extends Resource

func choose_card(enemy: Combatant, battle: BattleState) -> Card:
	return null  # override

func choose_target(enemy: Combatant, battle: BattleState) -> Combatant:
	var targets := battle.opposing_team(enemy).filter(func(c): return not c.is_dead)
	if targets.is_empty():
		return null
	return targets[0]  # override for smarter targeting
