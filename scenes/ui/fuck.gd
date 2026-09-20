extends Sprite2D

@export var rotation_time: float = 10.0  # seconds for a full 360

func _process(delta: float) -> void:
	rotation += (TAU / rotation_time) * delta
