class_name TurnManager
extends RefCounted

signal turn_order_changed

var turn_order: Array[CombatantTurn] = []

var current_turn: CombatantTurn

func _active_turns() -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant.is_active_combatant())

func _next_active_turn() -> CombatantTurn:
	current_turn = _active_turns()[0]
	return _active_turns()[0]

func turns_of(combatant: Combatant) -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant == combatant)

func _sort_turns() -> void:
	turn_order.sort_custom(func(a, b): return a.recovery_time < b.recovery_time)
	turn_order_changed.emit()
	
func _round_over() -> bool:
	return _active_turns().is_empty()

func _advance_time() -> void:
	var active := _active_turns()
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
	current_turn.recovery_time += rc
	
#TODO
#run turn, where it executes start turn, waits for your bullshit (picking a card, executing effects, etc), and ends turn
#action queue, but it seems fucking complicated with little gain
