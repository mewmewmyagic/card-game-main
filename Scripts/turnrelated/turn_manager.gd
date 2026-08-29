class_name TurnManager
extends RefCounted

signal round_started(combatants: Array[Combatant])
signal round_ended

signal turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)

var battle: BattleState
var combatants: Array[Combatant] = []
var current_turn: Combatant

func start_round(new_combatants: Array[Combatant]) -> void:
	combatants = new_combatants.duplicate()

	for c in combatants:
		c.stats.reset_recovery_time()
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.build_hand()

	round_started.emit(_active_combatants())
	start_turn()

func end_round() -> void:
	print("DONE")
	start_round(combatants)

func end_turn(recovery_cost: int) -> void:
	current_turn.stats.set_recovery_time(recovery_cost)
	turn_ended.emit(current_turn)
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.5).timeout
	
	if _round_over():
		round_ended.emit()
		end_round()
		return
	
	start_turn()

func start_turn() -> void:
	current_turn = _next_combatant()
	print(current_turn.name)
	#for c in _active_combatants():
		#c.stats.recovery_time -= current_turn.stats.recovery_time #this stops the recov time from diverging
	turn_started.emit(current_turn)
	
	if current_turn.ai_behavior:
		current_turn.take_ai_turn(battle)

func _active_combatants() -> Array[Combatant]:
	return combatants.filter(func(c): return c.can_take_turn())

func _next_combatant() -> Combatant:
	var best: Combatant = null
	for c in _active_combatants():
		if best == null or c.stats.recovery_time < best.stats.recovery_time:
			best = c
	return best

func _round_over() -> bool:
	return _active_combatants().is_empty()
