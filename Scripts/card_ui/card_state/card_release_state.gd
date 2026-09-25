extends CardState

var has_target: bool
func enter() -> void: #you cant change state in an enter state
	card_ui.color.color = Color.PURPLE
	has_target = not card_ui.targets.is_empty()
	if has_target:
		var target := card_ui.targets[0].get_parent() as Combatant
		EventBus.card_play_requested.emit(card_ui.card, card_ui.owner_combatant, target)

#if there is a valid target, itll get destroyed. otherwise this happens
#problem = its on input. if u release your mouse is outside of screen, itll get stuck there
#temporary, maybe? 
func on_input (_event: InputEvent) -> void:
	card_ui.request_snap_back.emit()
	transition_requested.emit(self, CardState.State.BASE)
