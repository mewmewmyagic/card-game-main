extends Stats
class_name CombatantStats

signal stamina_changed(new_stamina: int)

@export var OPENING_HAND_SIZE := 5
@export var max_hand_size := 10
@export var max_stamina: int
@export var starting_pile: CardPile

var stamina: int: set = set_stamina

func reset_shield() -> void:
	self.shield = 0

func set_stamina(value: int) -> void:
	stamina = value
	stamina_changed.emit(stamina)
	
func reset_stamina() -> void:
	self.stamina = max_stamina
	
func enough_stamina(card: Card) -> bool:
	if card == null:
		return false
	return stamina >= card.stamina_cost
	
func create_instance() -> Resource:
	var instance: CombatantStats = self.duplicate()
	instance.health = max_health
	instance.shield = 0
	instance.reset_stamina()
	return instance
	
