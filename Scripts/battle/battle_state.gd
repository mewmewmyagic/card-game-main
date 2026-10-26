class_name BattleState
extends RefCounted

var allies: Array[Combatant] = []
var enemies: Array[Combatant] = []
var neutral: Array[Combatant] = []

func literally_all_combatants() -> Array[Combatant]:    # this is never getting used i think
	return allies + enemies + neutral

func all_combatants() -> Array[Combatant]:          # who counts for win/lose and who ALL hits
	return allies + enemies

func opposing_team(c: Combatant) -> Array[Combatant]:
	if c in allies: return enemies
	if c in enemies: return allies
	
	push_error("Not found opposing team")
	return all_combatants()

func same_team(c: Combatant) -> Array[Combatant]:
	if c in allies: return allies
	if c in enemies: return enemies
	
	push_error("Not found same team")
	return neutral

func alive(team: Array[Combatant]) -> Array[Combatant]:
	var result: Array[Combatant] = []
	for c in team:
		if not c.is_dead:
			result.append(c)
	return result

func battle_is_over() -> bool:
	return alive(allies).is_empty() or alive(enemies).is_empty()
