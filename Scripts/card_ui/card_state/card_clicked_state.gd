extends CardState

var _press_position: Vector2

func enter() -> void:
	card_ui.color.color = Color.ORANGE
	card_ui.drop_point_detector.monitoring = true
	_press_position = card_ui.get_global_mouse_position()

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
