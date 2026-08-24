extends CanvasLayer


@export var battle_state: BattleState
@export var the_hand_ui: TheHand
@export var stamina_ui: StaminaUI
@export var turn_ui: TurnUI
@export var draw_pile_ui: CardPileUI
@export var discard_pile_ui: CardPileUI

func _ready() -> void:
	the_hand_ui.bind(battle_state.player.hand_pile, battle_state.card_play_resolver, battle_state.player)
	stamina_ui.bind(battle_state.player.stats)
	turn_ui.bind(battle_state.turn_manager)
	draw_pile_ui.bind(battle_state.player.draw_pile)
	discard_pile_ui.bind(battle_state.player.discard_pile)
	# BattleUI._ready() — confirm these two lines exist:
	battle_state.turn_manager.turn_started.connect(func(_c): the_hand_ui._update_playability_ui())
	battle_state.turn_manager.turn_ended.connect(func(_c): the_hand_ui._update_playability_ui())
