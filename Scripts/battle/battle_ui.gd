extends CanvasLayer

@export var battle_state: BattleState
@export var the_hand_ui: TheHand
@export var stamina_ui: StaminaUI
@export var turn_ui: TurnUI
@export var draw_pile_ui: CardPileUI
@export var discard_pile_ui: CardPileUI
@export var skip_round_ui: SkipRoundButton

#change this shit so when its enemies turn (actually, more like when its playing
#an animation it doesnt show the ui, ala limbus
func _ready() -> void:
	turn_ui.bind(battle_state.turn_manager)

	#signals to make hand not playable in between turns
	battle_state.turn_manager.turn_started.connect(func(_c): the_hand_ui._update_interactability_ui())
	battle_state.turn_manager.turn_ended.connect(func(_c): the_hand_ui._update_interactability_ui())
	
	battle_state.turn_manager.turn_started.connect(_on_different_ally_turn_started)

func _on_different_ally_turn_started(combatant: Combatant) -> void:
	if combatant.ai_behavior:
		return
	the_hand_ui.bind(battle_state.card_play_manager, combatant)
	stamina_ui.bind(combatant.stats)
	draw_pile_ui.bind(combatant.draw_pile)
	discard_pile_ui.bind(combatant.discard_pile)
	skip_round_ui.bind(combatant)
	
func unbind_all() -> void:
	the_hand_ui._unbind()
	stamina_ui.unbind()
	draw_pile_ui.unbind()
	discard_pile_ui.unbind()
