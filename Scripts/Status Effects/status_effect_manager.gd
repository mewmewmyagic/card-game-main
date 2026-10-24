extends Node
class_name StatusEffectHandler

#the way status' work in this is that theres a resource for shit like id and max count etc and a .gd for logic
#each status connects to what event triggers it
@export var parent: Combatant
@export var status_effect_icon: PackedScene
@export var status_effect_area: GridContainer
@export var status_effects: Dictionary = {} #{id: string, status_effect: status}

func apply_status(status: StatusEffect, stack: int = 0, count: int = 0) -> void:
	if not status_effects.has(status.id):
		var instance := status.duplicate() as StatusEffect
		status_effects[instance.id] = instance
		
		if count == 0:
			count = 1
		if stack == 0:
			stack = 1

		instance.init(parent, self)
		
		instance.add_count(count)
		instance.add_stack(stack)
		
		var icon := status_effect_icon.instantiate() as StatusEffectIcon
		icon.status = instance
		status_effect_area.add_child(icon)
		
		instance.on_effect_applied()
	else:
		var existing := status_effects[status.id] as StatusEffect

		existing.add_count(count)
		existing.add_stack(stack)
		
		existing.on_effect_applied()

func remove_status(id: String) -> void:
	if not status_effects.has(id):
		return
	var s: StatusEffect = status_effects[id]
	status_effects.erase(id)
	
	s.on_effect_removed()
	s.removed.emit()
