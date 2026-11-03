class_name TurnManager
extends RefCounted

signal turn_order_changed

var battle_state: BattleState

func get_sorted_turns() -> Array[CombatantTurn]:
	var all: Array[CombatantTurn] = []
	for c in battle_state.literally_all_combatants():
		all.append_array(c.stats.turn_slots)
		
	all.sort_custom(func(a, b): if a.recovery_time != b.recovery_time: return a.recovery_time < b.recovery_time)
	return all

func get_active_turns() -> Array[CombatantTurn]:
	return get_sorted_turns().filter(func(t): return t.combatant.is_active_combatant())

func set_current_turn() -> void:
	var active := get_active_turns()
	if active.is_empty():
		push_error("no active combatants")
		return
	battle_state.current_turn = active[0]

func clear_turns() -> void:
	for c in battle_state.literally_all_combatants():
		c.stats.turn_slots.clear()
	turn_order_changed.emit()
	
func round_over() -> bool:
	return get_active_turns().is_empty()

func _advance_time() -> void:
	var active := get_active_turns()
	var should_advance := true
	if active.is_empty():
		return
	while (true):
		for t in active:
			if (t.recovery_time <= 0):
				should_advance = false
				break
		if not should_advance:
			break
		for t in active:
			t.recovery_time = maxf(0, t.recovery_time - t.combatant.stats.agility * 1.0)

func _add_recovery_cost(rc: int) -> void:
	battle_state.current_turn.recovery_time += rc
