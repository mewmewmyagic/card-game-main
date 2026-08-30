extends CanvasLayer


@export var battle_state: BattleState
@export var the_hand_ui: TheHand
@export var stamina_ui: StaminaUI
@export var turn_ui: TurnUI
@export var draw_pile_ui: CardPileUI
@export var discard_pile_ui: CardPileUI

func _ready() -> void:
	var first_ally := battle_state.allies[0]
	the_hand_ui.bind(first_ally.hand_pile, battle_state.card_play_resolver, battle_state.allies[0])
	stamina_ui.bind(first_ally.stats)
	turn_ui.bind(battle_state.turn_manager)
	draw_pile_ui.bind(first_ally.draw_pile)
	discard_pile_ui.bind(first_ally.discard_pile)
	# BattleUI._ready() — confirm these two lines exist:
	battle_state.turn_manager.turn_started.connect(func(_c): the_hand_ui._update_interactability_ui())
	battle_state.turn_manager.turn_ended.connect(func(_c): the_hand_ui._update_interactability_ui())
	battle_state.turn_manager.turn_started.connect(_on_different_ally_turn_started)

func _on_different_ally_turn_started(combatant: Combatant) -> void:
	if combatant.ai_behavior != null: #if it already has ai
		return
	the_hand_ui.bind(combatant.hand_pile, battle_state.card_play_resolver, combatant)
	stamina_ui.bind(combatant.stats)
