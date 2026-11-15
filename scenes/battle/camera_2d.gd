extends Camera2D

@export var speed: float = 300.0

func _process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	global_position += direction * speed * delta
