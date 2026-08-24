class_name BattleState
extends Node
const OPENING_HAND_SIZE := 5

#_ready() must run before battle uis ready(), aka battle state is in higher order of the scene tree

@export var player: Combatant
@export var enemy: Combatant
var play_history: Array[Card] = []
var card_play_resolver: CardPlayResolver
var turn_manager: TurnManager

func _ready() -> void:
	card_play_resolver = CardPlayResolver.new()
	card_play_resolver.battle = self
	
	turn_manager = TurnManager.new()
	turn_manager.battle = self
	#turn_manager.round_ended.connect(_on_round_ended)
	
	player.bind_turn_manager(turn_manager)
	enemy.bind_turn_manager(turn_manager)
	
	turn_manager.start_round([player, enemy])
	
	EventBus.card_play_requested.connect(_on_player_card_play_requested)


#func play_card(card: Card, source:Combatant, target: Combatant) -> bool:
	#var success := card_play_resolver.resolve(card, source, target)
	#print("card_played")
	#if success:
		#play_history.append(card)
		#EventBus.card_played.emit(card, source)
		#turn_manager.end_turn()
	#else:
		#EventBus.card_play_rejected.emit(card, source)
	#return success

func _on_player_card_play_requested(card_ui: CardUI, target: Combatant) -> void:
	var success := card_play_resolver.resolve(card_ui.card, player, target)
	if not success:
		EventBus.card_ui_play_rejected.emit(card_ui)

#func _on_round_ended() -> void:
	#player.discard_hand()
	#player.build_hand()
