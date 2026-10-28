# EnemyAIBehavior.gd
class_name CombatantAIBase
extends Resource

func choose_card(_user: Combatant, _battle: BattleManager) -> Card:
	return null

func choose_target(_user: Combatant, _battle: BattleManager) -> Combatant:
	return null
