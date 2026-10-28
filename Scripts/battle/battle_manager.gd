class_name BattleManager
extends Node

#_ready() must run before battle uis ready(), aka battle state is in higher order of the scene tree

#TODO 2 source of allies/enemies/neutral??
@export var allies: Array[Combatant]
@export var enemies: Array[Combatant]
@export var neutral: Array[Combatant]

@export_file("*.tscn") var next_scene: String

enum Stage {START, INPUT, OUTPUT, END}

signal turn_started(combatant: Combatant)
signal ally_turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)
signal battle_ended

var card_play_manager: CardPlayManager
var turn_manager: TurnManager
var battle_state: BattleState
#var damage_handler: damage handler
#var action_queue: actionqueue

var stage: Stage = Stage.START

func _ready() -> void:
	turn_manager = TurnManager.new()
	battle_state = BattleState.new()
	
	card_play_manager = CardPlayManager.new()
	card_play_manager.battle_state = battle_state
	card_play_manager.card_resolved.connect(_on_card_resolved)
	card_play_manager.battle_manager = self
	
	ActionQueue.queue.clear()
	
	EventBus.card_play_requested.connect(card_play_manager._on_player_card_play_requested)
	
	await get_tree().process_frame
	
	battle_state.allies = allies
	battle_state.enemies = enemies
	battle_state.neutral = neutral
	
	for c in battle_state.allies:
		c.sprite_2d.scale.x *= -1
		
	start_round()

#currently, since round sort round directly sorts the combatants array, 
func start_round() -> void:
	for c in battle_state.literally_all_combatants():
		c.stats.reset_stamina()
		c.stats.reset_shield()
		c.card_piles_handler.build_hand()
		c.card_piles_handler.card_play_history.clear()
		
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
	if turn_manager.round_over(): #no ones active for some reason
		await end_battle()      
		return
	
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
		take_ai_turn(turn_manager.current_turn.combatant)
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
	
	if battle_state.battle_is_over():
		await end_battle()
		return
	
	if turn_manager.round_over():
		end_round()
		return
	
	turn_manager._advance_time()
	start_turn()
	
	
func _set_stage(new_stage: Stage):
	stage = new_stage
	EventBus.turn_stage_changed.emit()

func end_battle() -> void:
	battle_ended.emit()
	await ActionQueue.drain()
	if not next_scene.is_empty():
		SceneLoader.load_scene(next_scene)

		
func _on_card_resolved(_s: Combatant, c: Card) -> void:
	turn_manager._add_recovery_cost(c.recovery_cost)
	output_phase()
	
func take_ai_turn(ai: Combatant) -> void:
	if ai.ai_behavior == null:
		push_error("how you gon call this and not have ai behaviour you whack ass")
		return
	var card := ai.ai_behavior.choose_card(ai, self)
	var target := ai.ai_behavior.choose_target(ai, self)
	
	if card == null or target == null:
		output_phase()
		return

	EventBus.card_play_requested.emit(card, ai, target)
