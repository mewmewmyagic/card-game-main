extends PlayerState

const SPEED := 175.0

func physics_update(_delta: float) -> void:
	var input_dir := _get_input_dir()

	if input_dir == Vector2.ZERO:
		transition_requested.emit(self, PlayerState.State.IDLE)
		return

	player.facing = input_dir
	player.body.velocity = input_dir.normalized() * SPEED
	player.body.move_and_slide()

func _get_input_dir() -> Vector2:
	var dir := Vector2.ZERO
	if Input.is_action_pressed("Down"):
		dir.y = 1
	elif Input.is_action_pressed("Up"):
		dir.y = -1

	if Input.is_action_pressed("Right"):
		dir.x = 1
	elif Input.is_action_pressed("Left"):
		dir.x = -1

	return dir
	
func on_input (_event: InputEvent) -> void:
	if _event.is_action_released("Shift"):
		transition_requested.emit(self, PlayerState.State.WALK)
