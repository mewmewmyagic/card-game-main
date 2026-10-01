extends PlayerState

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("Down") or event.is_action_pressed("Up") \
			or event.is_action_pressed("Left") or event.is_action_pressed("Right"):
		transition_requested.emit(self, PlayerState.State.WALK)
