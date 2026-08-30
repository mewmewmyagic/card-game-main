extends Node2D
class_name Combatant

signal im_dead(combatant: Combatant)

@export var stats: CombatantStats #: set = set_combatant_stats
@export var ai_behavior: EnemyAIBehavior
@export var myname: String

@export var starting_deck: CardPile
@export var draw_pile: CardPile
@export var discard_pile: CardPile
@export var hand_pile: CardPile

@export var battle_state: BattleState

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var stats_ui: CombatantStatsUI = $StatsUI as CombatantStatsUI

var is_active_turn: bool = false
var is_dead: bool = false
	
	
func _on_self_turn_started() -> void:
	is_active_turn = true
		
func _on_self_turn_ended() -> void:
	is_active_turn = false

func _ready() -> void:
	build_deck()
	stats = stats.create_instance()
	stats.stats_changed.connect(_on_stats_changed)
	_bind_stats_ui()


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
	
#draws from draw_pile. draw_pile empty? fill it with discard pile then draw. discard empty? some stupid shit happened
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
	discard_hand() #hand gets discarded and added back to discard pile
	for i in stats.OPENING_HAND_SIZE:
		draw_to_hand()
	
	
func can_act() -> bool:
	if is_dead:
		return false
	if not is_active_turn:
		return false
	return has_playable_card()
	
func can_take_turn() -> bool:
	if is_dead:
		return false
	return has_playable_card()
	
func has_playable_card() -> bool:
	if hand_pile.cards.is_empty():
		return false
		
	for card in hand_pile.cards:
		if stats.enough_stamina(card):
			return true
	return false
	
	
func _bind_stats_ui() -> void:
	stats_ui.bind(stats)
	_on_stats_changed()

#why is this here? and why is it like this? no clue
func _on_stats_changed() -> void:
	if stats.health <= 0:
		_die()
	
func take_damage(damage: int) ->void:
	if (stats.health <= 0):
		return
		
	var damage_to_shield := int(min(damage, stats.shield))
	var damage_to_health := damage - damage_to_shield

	stats.shield -= damage_to_shield
	stats.health -= damage_to_health

func gain_shield(shield: int) -> void:
	stats.shield += shield                

func _die() -> void:
	is_dead = true
	self.stats.recovery_time = 9999
	im_dead.emit(self)
	
	
#TODO i dont want this here bruh
func take_ai_turn(battle: BattleState) -> void:
	if ai_behavior == null:
		return
	var card := ai_behavior.choose_card(self, battle)
	if card == null:
		#TODO this wont work
		#battle.turn_manager.end_turn(card.recovery_cost)
		return
	var target := ai_behavior.choose_target(self, battle)
	battle.resolve_ai_card_play(self, card, target)
