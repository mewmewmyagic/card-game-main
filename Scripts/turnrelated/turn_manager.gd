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
var current_turn: Combatant

#currently, since round sort round directly sorts the combatants array, 
func start_round(starting_combatants: Array[Combatant]) -> void:
	combatants = starting_combatants.duplicate()
	
	for c in combatants:
		c.stats.reset_recovery_time()
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.build_hand()

	round_started.emit()
	start_turn()

func end_round() -> void:
	#battle.battle_ui.unbind_all() #TODO
	turn_order_changed.emit()
	start_round(combatants)

func start_turn() -> void:
	advance_time()
	_sort_combatant()
	
	current_turn = _next_active_combatant()
	current_turn._on_self_turn_started()
	
	EventBus.turn_started.emit()
	turn_started.emit(current_turn)
	
	if current_turn.ai_behavior:
		current_turn.take_ai_turn(battle)
	else:
		ally_turn_started.emit(current_turn)
		
func end_turn() -> void:
	current_turn._on_self_turn_ended()
	EventBus.turn_ended.emit()
	turn_ended.emit(current_turn)
	
	await current_turn.anim_done
	if _round_over():
		round_ended.emit()
		end_round()
		return
	
	start_turn()

func _active_combatants() -> Array[Combatant]:
	return combatants.filter(func(c): return c.is_active_combatant())

func _next_active_combatant() -> Combatant:
	return _active_combatants()[0]
	
func advance_time() -> void:
	var active := _active_combatants()
	var should_advance := true
	if active.is_empty():
		return

	while (true):
		for c in active:
			if (c.stats.recovery_time <= 0):
				should_advance = false
				break

		if not should_advance:
			break

		for c in active:
			c.stats.recovery_time = maxf(0, c.stats.recovery_time - c.stats.agility * 1.0)
			
func _sort_combatant() -> void:
	combatants.sort_custom(func(a, b): return a.stats.recovery_time < b.stats.recovery_time)
	turn_order_changed.emit()
	
func _round_over() -> bool:
	return _active_combatants().is_empty()
