class_name BattleState
extends RefCounted

var allies: Array[Combatant] = []
var enemies: Array[Combatant] = []
var neutral: Array[Combatant] = []

var turn_order: Array[CombatantTurn] = []
var current_turn: CombatantTurn
var round_number: int = 0

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

func turns_of(c: Combatant) -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant == c)

func add_recovery_time_to_every(c: Combatant, amount: int) -> void:
	for t in turns_of(c):
		t.recovery_time += amount
		
func add_recovery_time_to_current(amount: int) -> void:
		current_turn.recovery_time += amount
	#turn_order_changed.emit()
