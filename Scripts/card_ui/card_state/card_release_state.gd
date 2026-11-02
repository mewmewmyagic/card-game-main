extends CardState

func enter() -> void:
	if card_ui.target != null:
		var target := card_ui.target
		EventBus.card_play_requested.emit(card_ui.card, card_ui.owner_combatant, target)
		card_ui.request_snap_back.emit()
		call_deferred("_return_to_base")
	else:
		card_ui.request_snap_back.emit()
		call_deferred("_return_to_base") #calls at the end of frame so you should already have "entered" this state before telling to fuck f

func _return_to_base() -> void:
	transition_requested.emit(self, CardState.State.BASE)
