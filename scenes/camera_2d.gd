extends Camera2D

@export var player: CharacterBody2D
var tween_duration = 1.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = create_tween()
	
	tween.tween_property(self, "position", player.position, tween_duration)
