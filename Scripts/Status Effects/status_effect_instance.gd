extends Node
class_name StatusEffectInstance

signal count_changed
signal stack_changed

var data: StatusEffect
var parent: Combatant
var stack: int = 0
var count: int = 0

func init(p_status_effect: StatusEffect, p_c: Combatant) -> void:
	self.definition = p_status_effect
	self.parent = p_c
	
func queue_status_action() -> void:
	pass
	#ActionQueue.push_back(StatusProcAction.create(self))

func proc_status_effect() -> void:
	pass
	
func on_effect_applied() -> void:
	pass

func on_effect_removed() -> void:
	pass
	
func add_count(n: int) -> void:
	count = clamp(count + n, 0, data.max_count)
	count_changed.emit()
	
func add_stack(n: int) -> void:
	stack = clamp(stack + n, 0, data.max_stack)
	stack_changed.emit()
