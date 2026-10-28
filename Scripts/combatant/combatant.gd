extends Node2D
class_name Combatant

signal im_dead(combatant: Combatant)
signal card_played(card: Card)
signal anim_done

@export var stats: CombatantStats #: set = set_combatant_stats
@export var ai_behavior: CombatantAIBase
@export var combatant_name: String

@export var status_manager: StatusEffectHandler
@export var modifier_manager: ModifierManager
@export var card_piles_handler: CardPilesHandler

@export var appearance: CombatantSpriteResource
@onready var sprite_2d: CombatantAnimationPlayer = $AnimatedSprite2D

@export var skill_container: HandDisplay
@export var stats_ui: CombatantStatsUI


var is_current_turn: bool = false
var is_playing: bool = false
var is_dead: bool = false
	
	
func _on_self_turn_started() -> void:
	pass
	
func _on_self_turn_ended() -> void:
	pass

func _ready() -> void:
	sprite_2d.bind(appearance)
	card_piles_handler.setup(stats.starting_pile, stats.max_hand_size, stats.OPENING_HAND_SIZE)
	stats = stats.create_instance()
	stats.stats_changed.connect(check_if_dead)
	bind()

func bind() -> void:
	stats_ui.bind(stats)
	status_manager.parent = self
	card_piles_handler.hand_pile.card_pile_size_changed.connect(skill_container.refresh_display)

func is_active_combatant() -> bool:
	if is_dead:
		return false
	return has_playable_card()
	
func has_playable_card() -> bool:
	if card_piles_handler.hand_pile.cards.is_empty():
		return false
		
	for card in card_piles_handler.hand_pile.cards:
		if stats.enough_stamina(card):
			return true
	return false

#why is this here? and why is it like this? no clue
func check_if_dead() -> void:
	if stats.health <= 0:
		_die()
	
	
	
func apply_damage(to_shield: int, to_health: int) -> void:
	if is_dead:
		return
	stats.shield -= to_shield
	stats.health -= to_health
	
func gain_shield(shield: int) -> void:
	stats.shield += shield                

func _die() -> void:
	is_dead = true
	stats_ui.visible = false
	im_dead.emit(self)
	
	
func play_skill_animation(card: Card) -> void:
	sprite_2d.play_card_animation(appearance.get_animation_for_card(card))
	await sprite_2d.animation_finished
	
	emit_signal("anim_done")

func play_other_animation() -> void:
	if appearance == null or sprite_2d == null:
		return
	sprite_2d.play_card_animation("idle")
	emit_signal("anim_done")
