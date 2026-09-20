extends CardState

func enter() -> void:
	CardState.any_card_dragging = true
	card_ui.z_index = 10 
	card_ui.color.color = Color.NAVY_BLUE
	
func exit() -> void:
	CardState.any_card_dragging = false
	card_ui.z_index = 0 #now bottom
	
func on_input (event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if cancel:
		
		transition_requested.emit(self,  CardState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
