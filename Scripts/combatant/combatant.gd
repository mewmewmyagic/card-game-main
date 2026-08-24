extends Node2D
class_name Combatant

@export var stats: CombatantStats : set = set_combatant_stats
@export var ai_behavior: EnemyAIBehavior
@export var myname: String

@export var starting_deck: CardPile
@export var draw_pile: CardPile
@export var discard_pile: CardPile
@export var hand_pile: CardPile

@export var battle_state: BattleState

@onready var sprite_2d: Sprite2D = $Sprite2D


@onready var stats_ui: StatsUI = $StatsUI as StatsUI

var is_active_turn: bool = false

func bind_turn_manager(turn_manager: TurnManager) -> void:
	if not turn_manager.turn_started.is_connected(_on_self_turn_started) and not turn_manager.turn_ended.is_connected(_on_self_turn_ended):
		turn_manager.turn_started.connect(_on_self_turn_started)
		turn_manager.turn_ended.connect(_on_self_turn_ended)
	
func _on_self_turn_started(combatant: Combatant) -> void:
	if combatant == self:
		is_active_turn = true
		
func _on_self_turn_ended(combatant: Combatant) -> void:
	if combatant == self:
		is_active_turn = false
		
func can_act() -> bool:
	return is_active_turn

func _ready() -> void:
	build_deck()
	for card in draw_pile.cards:
		pass

func build_deck() -> void:
	for card in starting_deck.cards:
		draw_pile.add_card(card.duplicate())
	draw_pile.shuffle()

func discard_hand() -> void:
	if hand_pile.empty():
		return
	for card in hand_pile.cards.duplicate():
		discard_pile.add_card(card)
	hand_pile.clear()
	
func draw_to_hand() -> void:
	if draw_pile.empty():
		if discard_pile.empty():
			return
		draw_pile.cards = discard_pile.cards.duplicate()
		discard_pile.clear()
		draw_pile.shuffle()
	var card := draw_pile.draw_card()
	hand_pile.add_card(card)
	
func build_hand() -> void:
	discard_hand()
	for i in stats.OPENING_HAND_SIZE:
		draw_to_hand()
		

func has_playable_card() -> bool:
	
	if hand_pile.cards.is_empty():
		print("lol %s %s" % [myname, hand_pile.cards.size()])
		return false
		
	for card in hand_pile.cards:
		if stats.can_play_card(card):
			return true
	return false

func take_ai_turn(battle: BattleState) -> void:
	if ai_behavior == null:
		return
	var card := ai_behavior.choose_card(self, battle)
	if card == null:
		#TODO this wont work
		#battle.turn_manager.end_turn(card.recovery_cost)
		return
	var target := ai_behavior.choose_target(self, battle)
	battle.card_play_resolver.resolve(card, self, target)

func set_combatant_stats(value: CombatantStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		
	update_player()
	
func update_player() -> void:
	if not stats is CombatantStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()
	

func update_stats()->void:
	stats_ui.update_stats(stats)
	if stats.health <= 0:
		print("yeah die")
		queue_free()  
	
func take_damage(damage: int) ->void:
	if (stats.health <= 0):
		return
		
	var damage_to_shield := int(min(damage, stats.shield))
	var damage_to_health := damage - damage_to_shield

	stats.shield -= damage_to_shield
	stats.health -= damage_to_health

func gain_shield(shield: int) -> void:
	stats.shield += shield                
