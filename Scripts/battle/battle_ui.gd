extends CanvasLayer

@export var battle_state: BattleManager
@export var the_hand_ui: PlayerHand
@export var stamina_ui: StaminaUI
@export var turn_ui: TurnOrderUI
@export var draw_pile_ui: CardPileUI
@export var discard_pile_ui: CardPileUI
@export var skip_round_ui: SkipRoundButton

#change this shit so when its enemies turn (actually, more like when its playing
#an animation it doesnt show the ui, ala limbus
func _ready() -> void:
	turn_ui.bind(battle_state.turn_manager)

	EventBus.turn_stage_changed.connect(the_hand_ui._update_interactability_ui)
	
	battle_state.turn_started.connect(_on_different_ally_turn_started)
	battle_state.battle_ended.connect(hide_all)

func _on_different_ally_turn_started(combatant: Combatant) -> void:
	if combatant.ai_behavior:
		return
	
	the_hand_ui.bind(battle_state.card_play_manager, combatant)
	stamina_ui.bind(combatant.stats)
	draw_pile_ui.bind(combatant.draw_pile)
	discard_pile_ui.bind(combatant.discard_pile)
	skip_round_ui.bind(combatant, battle_state)
	
func unbind_all() -> void:
	the_hand_ui._unbind()
	stamina_ui.unbind()
	draw_pile_ui.unbind()
	discard_pile_ui.unbind()
	
func hide_all() -> void:
	the_hand_ui.hide()
	stamina_ui.hide()
	draw_pile_ui.hide()
	discard_pile_ui.hide()
	skip_round_ui.hide()
	turn_ui.hide()
