class_name BattleManager
extends Node

#_ready() must run before battle uis ready(), aka battle state is in higher order of the scene tree
@export var allies: Array[Combatant]
@export var enemies: Array[Combatant]
@export_file("*.tscn") var next_scene: String

enum Stage {START, INPUT, OUTPUT, END}

signal turn_started(combatant: Combatant)
signal ally_turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)

var card_play_manager: CardPlayManager
var turn_manager: TurnManager
#var damage_handler: damage handler
#var action_queue: actionqueue

var play_history: Array[Card] = []
var stage: Stage = Stage.START

func _ready() -> void:
	card_play_manager = CardPlayManager.new()
	card_play_manager.battle = self
	
	turn_manager = TurnManager.new()
	
	ActionQueue.queue.clear()
	
	EventBus.card_play_requested.connect(card_play_manager._on_player_card_play_requested)
	
	await get_tree().process_frame
	
	for c in allies:
		c.sprite_2d.scale.x *= -1
		
	start_round()

#currently, since round sort round directly sorts the combatants array, 
func start_round() -> void:
	for c in all_combatants():
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.build_hand()
		
		var turn := CombatantTurn.new()
		turn.combatant = c
		turn_manager.turn_order.append(turn)
	
	turn_manager.turn_order.shuffle()
	
	EventBus.round_started.emit()
	start_turn()

func end_round() -> void:
	#battle.battle_ui.unbind_all() #TODO
	turn_manager.turn_order.clear()
	turn_manager.turn_order_changed.emit()
	
	EventBus.round_ended.emit()
	
	start_round()

func start_turn() -> void:
	turn_manager.sort_turns()
	
	turn_manager.set_next_active_turn()
	_set_stage(Stage.START)
	
	EventBus.turn_started.emit()
	turn_started.emit(turn_manager.current_turn.combatant)
	
	await ActionQueue.drain()
	
	input_phase()

func input_phase() -> void:
	turn_manager.current_turn.combatant.is_playing = true
	_set_stage(Stage.INPUT)
	
	if turn_manager.current_turn.combatant.ai_behavior:
		turn_manager.current_turn.combatant.take_ai_turn(self)
	else:
		ally_turn_started.emit(turn_manager.current_turn.combatant) #this is fucking useless
	
func output_phase() -> void:
	turn_manager.current_turn.combatant.is_playing = false
	_set_stage(Stage.OUTPUT)
	
	await ActionQueue.drain()
	
	end_turn()

func end_turn() -> void:
	_set_stage(Stage.END)
	
	EventBus.turn_ended.emit()
	turn_ended.emit(turn_manager.current_turn.combatant)
	
	await ActionQueue.drain()
	
	check_death()
	
	if turn_manager.round_over():
		end_round()
		return
	
	turn_manager._advance_time()
	start_turn()
	
func _set_stage(new_stage: Stage):
	stage = new_stage
	EventBus.turn_stage_changed.emit()



func all_combatants() -> Array[Combatant]:
	return allies + enemies
	
func opposing_team(c: Combatant) -> Array[Combatant]:
	if c in allies:
		return enemies
	return allies
	
func same_team(c: Combatant) -> Array[Combatant]:
	if c in allies:
		return allies
	return enemies
	
func check_death() -> void:
	var allies_alive := allies.any(func(c): return not c.is_dead)
	var enemies_alive := enemies.any(func(c): return not c.is_dead)
	
	if allies_alive and enemies_alive:
		return
		
	if next_scene != null:
		SceneLoader.load_scene(next_scene)

func resolve_ai_card_play(source: Combatant, card: Card, target: Combatant) -> void:
	var context := CardEffectContext.new()
	context.card = card
	context.source = source
	context.target = target
	card_play_manager.resolve(context)
