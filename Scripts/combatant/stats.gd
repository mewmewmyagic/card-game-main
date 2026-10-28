extends Resource
class_name Stats

signal stats_changed

@export var max_health: int = 1
@export var agility: float = 1.0

var health: int : set = set_health
var shield: int: set = set_shield


func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	stats_changed.emit()

func take_health_damage(value: int) -> void:
	health -= value
	
func get_percentage_health() -> float:
	if max_health <= 0.0:
		return 0.0

	return clampf(float(health) / float(max_health), 0.0, 1.0)
	
func set_shield(value: int) -> void:
	shield = clamp(value, 0, 999)
	stats_changed.emit()
	
func take_shield_damage(value: int) -> void:
	shield -= value
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.shield = 0
	return instance
	
	
	
