extends Node

# EventBus.gd

@warning_ignore_start("unused_signal")
signal card_play_requested(card: Card, source: Combatant, target: Combatant)
signal card_played(card: Card, source: Combatant)
signal card_play_rejected(card: Card, source: Combatant)
signal card_ui_play_rejected(card_ui: HandCardUI)  # UI-specific, see below
signal turn_end_request()

#Turns
signal round_started
signal round_ended
signal turn_ended
signal turn_started
signal turn_stage_changed

#CardUI
signal card_entered_area(card: Card, target: Combatant)
signal card_exited_area(card: Card, target: Combatant)
