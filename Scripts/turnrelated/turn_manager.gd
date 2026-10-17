class_name TurnManager
extends RefCounted

signal round_started()
signal round_ended

signal turn_started(combatant: Combatant)
signal ally_turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)

signal turn_order_changed
signal decision_made(play: Card)

var battle: BattleState
#all combatants currently in battle. some combatants arent active combatants (cant take turns) while others are
var combatants: Array[Combatant] = []
var turn_order: Array[CombatantTurn] = []
var current_turn: CombatantTurn

var _awaiting_decision := false



func submit(play: Card) -> void:
	if not _awaiting_decision:
		return
	_awaiting_decision = false
	decision_made.emit(play)
	


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
	
	var play: Card = await _get_card_decision(current_turn.combatant)

	# 3. do it: costs are paid and effects run now, the animation plays alongside
	if play != null:
		await play.execute(battle)

func end_turn() -> void:
	
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



func _get_card_decision(actor: Combatant) -> Card:
	if actor.ai_behavior:
		return actor.ai_behavior.choose_play(actor, battle)
	_awaiting_decision = true
	ally_turn_started.emit(actor)
	return await decision_made




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
			
func _add_recovery_cost(rc: int) -> void:
	current_turn.recovery_time += rc
	
#TODO
#run turn, where it executes start turn, waits for your bullshit (picking a card, executing effects, etc), and ends turn
#action queue, but it seems fucking complicated with little gain
