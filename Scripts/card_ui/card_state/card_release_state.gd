extends CardState

func enter() -> void:
	if card_ui.target != null:
		var target := card_ui.target
		EventBus.card_play_requested.emit(card_ui.card, card_ui.owner_combatant, target)
		card_ui.animator.move_to(card_ui.position_in_hand, card_ui.rotation_in_hand, 0.1)
		call_deferred("_return_to_base")
	else:
		card_ui.animator.move_to(card_ui.position_in_hand, card_ui.rotation_in_hand, 0.1)
		call_deferred("_return_to_base") #calls at the end of frame so you should already have "entered" this state before telling it to fuck off

func _return_to_base() -> void:
	transition_requested.emit(self, CardState.State.BASE)
