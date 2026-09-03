class_name BattleState
extends Node

#_ready() must run before battle uis ready(), aka battle state is in higher order of the scene tree

#@export var player: Combatant
#@export var enemy: Combatant

@export var allies: Array[Combatant]
@export var enemies: Array[Combatant]
@export var next_scene: PackedScene
#@export var combatants_in_battle: Array[Combatant]
var play_history: Array[Card] = []
var card_play_resolver: CardPlayResolver
var turn_manager: TurnManager

func _ready() -> void:
	card_play_resolver = CardPlayResolver.new()
	card_play_resolver.battle = self
	
	turn_manager = TurnManager.new()
	turn_manager.battle = self
	#turn_manager.round_ended.connect(_on_round_ended)
	
	turn_manager.start_round(all_combatants())
	
	for c in all_combatants():
		c.im_dead.connect(_on_combatant_died)
	EventBus.card_play_requested.connect(card_play_resolver._on_player_card_play_requested)
	
func all_combatants() -> Array[Combatant]:
	return enemies + allies
	
func opposing_team(c: Combatant) -> Array[Combatant]:
	if c in allies:
		return enemies
	return allies

func _on_combatant_died(_combatant: Combatant) -> void:
	var allies_alive := allies.any(func(c): return not c.is_dead)
	var enemies_alive := enemies.any(func(c): return not c.is_dead)
	
	if allies_alive and enemies_alive:
		return
		
	if next_scene != null:
		print("poepepe")
		get_tree().call_deferred("change_scene_to_packed", next_scene)

func resolve_ai_card_play(source: Combatant, card: Card, target: Combatant) -> void:
	var context := CardEffectContext.new()
	context.battle = self
	context.card = card
	context.source = source
	context.target = target
	card_play_resolver.resolve(context)
