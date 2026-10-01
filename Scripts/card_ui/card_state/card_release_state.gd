extends CardState

var has_target: bool

func enter() -> void:
	card_ui.color.color = Color.PURPLE
	has_target = not card_ui.targets.is_empty()
	if has_target:
		var target := card_ui.targets[0].get_parent() as Combatant
		EventBus.card_play_requested.emit(card_ui.card, card_ui.owner_combatant, target)
		if true: #currently if the card got rejected it just gets destroyed so itll either get destroyed or go back
			card_ui.request_snap_back.emit()
			call_deferred("_return_to_base")
	else:
		card_ui.request_snap_back.emit()
		call_deferred("_return_to_base") #calls at the end of frame so you should already have "entered" this state before telling to fuck f

func _return_to_base() -> void:
	transition_requested.emit(self, CardState.State.BASE)
