extends RefCounted
class_name TurnManager

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

	round_started.emit(combatants)
	battle.enemy.build_hand()
	battle.player.build_hand()
	start_turn()

func end_round() -> void:
	print("DONE")
	start_round(combatants)

func end_turn(recovery_cost: int) -> void:
	current_turn.stats.set_recovery_time(recovery_cost)
	turn_ended.emit(current_turn)
	
	if _round_over():
		round_ended.emit()
		end_round()
		return

	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.5).timeout
	start_turn()

func start_turn() -> void:
	current_turn = _next_combatant()
	print(current_turn.myname)
	turn_started.emit(current_turn)
	
	#TODO change
	if current_turn == battle.enemy:
		battle.enemy.take_ai_turn(battle)

func _next_combatant() -> Combatant:
	var best: Combatant = null
	for c in combatants:
		if not c.has_playable_card():
			continue
		if best == null or c.stats.recovery_time < best.stats.recovery_time:
			best = c
	return best

func _round_over() -> bool:
	for c in combatants:
		if c.has_playable_card():
			return false
	return true
