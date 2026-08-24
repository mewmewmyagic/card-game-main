extends Resource
class_name Stats

signal stats_changed

@export var max_health := 1
@export var OPENING_HAND_SIZE := 5
var health: int : set = set_health
var shield: int: set = set_shield


func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	stats_changed.emit()
	
func set_shield(value: int) -> void:
	shield = clamp(value, 0, 999)
	stats_changed.emit()
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.shield = 0
	return instance
	
	
	
