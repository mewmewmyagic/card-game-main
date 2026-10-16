class_name TurnManager
extends RefCounted

signal round_started()
signal round_ended

signal turn_started(combatant: Combatant)
signal ally_turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)

signal turn_order_changed

var battle: BattleState
#all combatants currently in battle. some combatants arent active combatants (cant take turns) while others are
var combatants: Array[Combatant] = []
var turn_order: Array[CombatantTurn] = []
var current_turn: CombatantTurn

#currently, since round sort round directly sorts the combatants array, 
func start_round(starting_combatants: Array[Combatant]) -> void:
	combatants = starting_combatants.duplicate()
	
	for c in combatants:
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.build_hand()
		
		var turn := CombatantTurn.new()
		turn.combatant = c
		turn_order.append(turn)
	
	turn_order.shuffle()
	round_started.emit()
	start_turn()

func end_round() -> void:
	#battle.battle_ui.unbind_all() #TODO
	turn_order.clear()
	turn_order_changed.emit()
	start_round(combatants)

func start_turn() -> void:
	_sort_turns()
	
	current_turn = _next_active_turn()
	current_turn.combatant._on_self_turn_started()
	
	EventBus.turn_started.emit()
	turn_started.emit(current_turn.combatant)
	
	if current_turn.combatant.ai_behavior:
		current_turn.combatant.take_ai_turn(battle)
	else:
		ally_turn_started.emit(current_turn.combatant)
		
func end_turn(recovery_cost: int) -> void:
	current_turn.recovery_time += recovery_cost
	
	current_turn.combatant._on_self_turn_ended()
	EventBus.turn_ended.emit()
	turn_ended.emit(current_turn.combatant)
	
	await current_turn.combatant.anim_done
	
	if _round_over():
		round_ended.emit()
		end_round()
		return
	
	_advance_time()
	start_turn()

func _active_turns() -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant.is_active_combatant())

func _next_active_turn() -> CombatantTurn:
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
