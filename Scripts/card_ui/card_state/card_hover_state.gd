extends CardState

func on_mouse_exited() -> void:
	card_ui.z_index = 0
	
	transition_requested.emit(self, CardState.State.BASE)

func enter() -> void:
	card_ui.z_index = 10
	card_ui.color.color = Color.GREEN_YELLOW
	var lift_position := Vector2(card_ui.position.x, -22.0)
	var rotation = 0
	card_ui.animator.move_to(lift_position, rotation, 0.1)

func exit() -> void:
	pass

func on_gui_input (event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
