extends Node
class_name StatusEffectManager

@export var parent: Combatant
@export var status_effects: Dictionary = {}

func apply_status(status: StatusEffect, stack: int = 1, count: int = 1) -> void:
	if not status_effects.has(status.id):
		var instance := status.duplicate() as StatusEffect
		status_effects[instance.id] = instance
		instance.init(parent, self)
		
		instance.stack += stack
		instance.count += count
	else:
		var existing := status_effects[status.id] as StatusEffect
		print(count)
		existing.stack += stack
		existing.count += count

func remove_status(id: String) -> void:
	if not status_effects.has(id):
		return
	var s: StatusEffect = status_effects[id]
	status_effects.erase(id)
	s.on_remove()
		
	
