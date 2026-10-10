extends CardState

const MIN_DRAG_TIME := 0.2  # seconds before a confirm is accepted

var drag_start_time := 0.0

func enter() -> void:
	CardState.any_card_dragging = true
	card_ui.z_index = 10
	card_ui.color.color = Color.NAVY_BLUE
	drag_start_time = Time.get_ticks_msec() / 1000.0
	set_process(true)

func exit() -> void:
	CardState.any_card_dragging = false
	card_ui.z_index = 0
	set_process(false)

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	card_ui.global_position = _get_screen_mouse_global() - card_ui.pivot_offset

func on_input(event: InputEvent) -> void:
	var cancel := event.is_action_pressed("right_mouse")
	var confirm := event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	var drag_time := Time.get_ticks_msec() / 1000.0 - drag_start_time

	if cancel:
		card_ui.request_snap_back.emit()
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm and drag_time > MIN_DRAG_TIME:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)

func _get_screen_mouse_global() -> Vector2:
	var window := get_window()
	var window_pos := Vector2(DisplayServer.mouse_get_position()) - Vector2(window.position)
	var viewport_pos := window.get_screen_transform().affine_inverse() * window_pos
	return card_ui.get_canvas_transform().affine_inverse() * viewport_pos
