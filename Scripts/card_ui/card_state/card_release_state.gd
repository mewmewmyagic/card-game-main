extends CardState

var has_target: bool
func enter() -> void: #you cant change state in an enter state
	card_ui.color.color = Color.PURPLE
	#card_ui.state.text = "RELEASED"
	has_target = not card_ui.targets.is_empty()
	if has_target:
		var target := card_ui.targets[0].get_parent() as Combatant
		EventBus.card_play_requested.emit(card_ui, target)
		
	
		
func on_input (_event: InputEvent) -> void:
	if has_target: 
		return
	else:
		transition_requested.emit(self, CardState.State.BASE)
