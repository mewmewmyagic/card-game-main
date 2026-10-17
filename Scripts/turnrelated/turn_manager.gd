class_name TurnManager
extends RefCounted

signal round_started(combatants: Array[Combatant])
signal round_ended

signal turn_started(combatant: Combatant)
signal ally_turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)

signal turn_order_changed

var battle: BattleState
#all combatants currently in battle. some combatants arent active combatants (cant take turns) while others are
var combatants: Array[Combatant] = []
<<<<<<< Updated upstream
var current_turn: Combatant
=======
var turn_order: Array[CombatantTurn] = []
var current_turn: CombatantTurn
>>>>>>> Stashed changes

#currently, since round sort round directly sorts the combatants array, 
func start_round(new_combatants: Array[Combatant]) -> void:
	combatants = new_combatants.duplicate()
	
	for c in combatants:
		c.stats.reset_recovery_time()
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.build_hand()
<<<<<<< Updated upstream

	round_started.emit(combatants)
=======
		
		var turn := CombatantTurn.new()
		turn.combatant = c
		turn_order.append(turn)
	
	turn_order.shuffle()
	
	round_started.emit()
>>>>>>> Stashed changes
	start_turn()

func end_round() -> void:
	#battle.battle_ui.unbind_all() #TODO
	start_round(combatants)

func start_turn() -> void:
	_sort_combatant()
	current_turn = _next_active_combatant()
	current_turn._on_self_turn_started()
	
	EventBus.turn_started.emit()
	#for i in range(combatants.size() - 1, -1, -1):
		#var c = combatants[i]
		#c.stats.recovery_time -= current_turn.stats.recovery_time
			
	turn_started.emit(current_turn)
	
<<<<<<< Updated upstream
	if current_turn.ai_behavior:
		current_turn.take_ai_turn(battle)
	else:
		ally_turn_started.emit(current_turn)
		
func end_turn(_recovery_cost: int) -> void: #TODO remove recov cost maybe
	current_turn._on_self_turn_ended()
	EventBus.turn_ended.emit()
	turn_ended.emit(current_turn)
=======
	if current_turn.combatant.ai_behavior:
		await current_turn.combatant.take_ai_turn(battle)
	else:
		ally_turn_started.emit(current_turn.combatant)

func end_turn() -> void:
	current_turn.combatant._on_self_turn_ended()
	EventBus.turn_ended.emit()
	await current_turn.combatant.anim_done
	turn_ended.emit(current_turn.combatant)
>>>>>>> Stashed changes
	
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

<<<<<<< Updated upstream
func _sort_combatant() -> void:
	combatants.sort_custom(func(a, b): return a.stats.recovery_time < b.stats.recovery_time)
=======


func _active_turns() -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant.is_active_combatant())

func _next_active_turn() -> CombatantTurn:
	return _active_turns()[0]

func turns_of(combatant: Combatant) -> Array[CombatantTurn]:
	return turn_order.filter(func(t): return t.combatant == combatant)

func _sort_turns() -> void:
	turn_order.sort_custom(func(a, b): return a.recovery_time < b.recovery_time)
>>>>>>> Stashed changes
	turn_order_changed.emit()
	
func _round_over() -> bool:
	return _active_combatants().is_empty()
