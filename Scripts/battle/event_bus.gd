extends Node

# EventBus.gd
signal card_play_requested(card_ui: CardUI, source: Combatant, target: Combatant)
signal card_played(card: Card, source: Combatant)
signal card_play_rejected(card: Card, source: Combatant)
signal card_ui_play_rejected(card_ui: CardUI)  # UI-specific, see below
