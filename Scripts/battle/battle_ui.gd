extends CanvasLayer


@export var battle_state: BattleState
@export var the_hand_ui: TheHand
@export var stamina_ui: StaminaUI
@export var turn_ui: TurnUI
@export var draw_pile_ui: CardPileUI
@export var discard_pile_ui: CardPileUI

#change this shit so when its enemies turn (actually, more like when its playing
#an animation it doesnt show the ui, ala limbus
func _ready() -> void:
	# BattleState._ready() has already run by this point (it's earlier in the
	# scene tree), which means turn_manager.start_round() already picked the
	# real first combatant. Read it instead of guessing allies[0] — with a
	# tied recovery_time=0 start, the sort has no reason to favor allies[0].
	var starting_combatant := battle_state.turn_manager.current_turn
	if starting_combatant == null or starting_combatant.ai_behavior != null:
		# First turn belongs to an AI (or something went wrong) — nothing's
		# playable yet either way, so any ally is a fine placeholder until
		# _on_different_ally_turn_started rebinds to whoever's really up.
		starting_combatant = battle_state.allies[0]

	the_hand_ui.bind(starting_combatant.hand_pile, battle_state.card_play_resolver, starting_combatant)
	stamina_ui.bind(starting_combatant.stats)
	turn_ui.bind(battle_state.turn_manager)
	draw_pile_ui.bind(starting_combatant.draw_pile)
	discard_pile_ui.bind(starting_combatant.discard_pile)

	battle_state.turn_manager.turn_started.connect(func(_c): the_hand_ui._update_interactability_ui())
	battle_state.turn_manager.turn_ended.connect(func(_c): the_hand_ui._update_interactability_ui())
	battle_state.turn_manager.turn_started.connect(_on_different_ally_turn_started)

func _on_different_ally_turn_started(combatant: Combatant) -> void:
	if combatant.ai_behavior != null:
		return
	the_hand_ui.bind(combatant.hand_pile, battle_state.card_play_resolver, combatant)
	stamina_ui.bind(combatant.stats)
