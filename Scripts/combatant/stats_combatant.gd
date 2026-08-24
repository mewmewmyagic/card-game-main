extends Stats
class_name CombatantStats

signal stamina_changed(new_stamina: int)

@export var cards_per_turn: int
@export var max_stamina: int

var recovery_time: int
var stamina: int: set = set_stamina

func reset_shield() -> void:
	self.shield = 0


func set_stamina(value: int) -> void:
	stamina = value
	stamina_changed.emit(stamina)
	stats_changed.emit()
	
func reset_stamina() -> void:
	self.stamina = max_stamina
	
func set_recovery_time(value: int) -> void:
	recovery_time += value
	stats_changed.emit()
	
func reset_recovery_time() -> void:
	recovery_time = 0
func can_play_card(card: Card) -> bool:
	return stamina >= card.stamina_cost
	
func create_instance() -> Resource:
	var instance: CombatantStats = self.duplicate()
	instance.health = max_health
	instance.shield = 0
	instance.reset_stamina()
	return instance
	
