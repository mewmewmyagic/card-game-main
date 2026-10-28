class_name TurnManager
extends RefCounted

signal turn_order_changed

var battle_state: BattleState

var turn_order: Array[CombatantTurn] = []
var current_turn: CombatantTurn

func get_active_turns() -> Array[CombatantTurn]:
	return battle_state.turn_order.filter(func(t): return t.combatant.is_active_combatant())

func set_next_active_turn() -> void:
	if (get_active_turns().is_empty()):
		push_error("no active combatants")
		return
		
	battle_state.current_turn = get_active_turns()[0]
	
func turns_of(combatant: Combatant) -> Array[CombatantTurn]:
	return battle_state.turn_order.filter(func(t): return t.combatant == combatant)

func sort_turns() -> void:
	battle_state.turn_order.sort_custom(func(a, b): return a.recovery_time < b.recovery_time)
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
