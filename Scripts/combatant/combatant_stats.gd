extends Stats
class_name CombatantStats

signal stamina_changed(new_stamina: int)
signal recov_time_changed

@export var OPENING_HAND_SIZE := 5
@export var max_hand_size := 10
@export var max_stamina: int
@export var starting_pile: CardPile

var recovery_time: int
var stamina: int: set = set_stamina

func reset_shield() -> void:
	self.shield = 0

func set_stamina(value: int) -> void:
	stamina = value
	stamina_changed.emit(stamina)
	
	
func reset_stamina() -> void:
	self.stamina = max_stamina
	
func set_recovery_time(value: int) -> void:
	recovery_time += value
	recov_time_changed.emit()

func drain(elapsed: float) -> void:
	recovery_time -= agility * elapsed
	if absf(recovery_time) < 0.0001:
		recovery_time = 0.0
	recov_time_changed.emit()
	
func time_to_ready() -> float:
	return recovery_time / maxf(agility, 0.01)
	
func reset_recovery_time() -> void:
	recovery_time = 0
	
func enough_stamina(card: Card) -> bool:
	return stamina >= card.stamina_cost
	
func create_instance() -> Resource:
	var instance: CombatantStats = self.duplicate()
	instance.health = max_health
	instance.shield = 0
	instance.reset_stamina()
	return instance
	
