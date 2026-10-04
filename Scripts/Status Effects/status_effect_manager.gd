extends Node
class_name StatusEffectManager

#Manages status effects of a combatant. for now it just has the logic for applying a status and removing them
#the way status' work in this is that theres a resource for shit like id and max count etc and a .gd for logic
#each status connects to what event triggers it
@export var parent: Combatant
@export var status_effects: Dictionary = {}

func apply_status(status: StatusEffect, stack: int = 0, count: int = 0) -> void:
	if not status_effects.has(status.id):
		var instance := status.duplicate() as StatusEffect
		status_effects[instance.id] = instance
		
		instance.init(parent, self)
		instance.add_count(count)
		instance.add_stack(stack)
	else:
		var existing := status_effects[status.id] as StatusEffect

		existing.add_count(count)
		existing.add_stack(stack)

func remove_status(id: String) -> void:
	if not status_effects.has(id):
		return
	var s: StatusEffect = status_effects[id]
	status_effects.erase(id)
	s.on_remove()
