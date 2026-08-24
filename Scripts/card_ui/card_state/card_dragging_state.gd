extends CardState

const drag_minimum_thershold := 0.05
var minimum_drag_time_elapsed := false

func enter() -> void:
	CardState.any_card_dragging = true
	card_ui.z_index = 10 #card is at the top layer
	card_ui.color.color = Color.NAVY_BLUE
	#card_ui.state.text = "DRAGGING"
	
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(drag_minimum_thershold, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)
	
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
