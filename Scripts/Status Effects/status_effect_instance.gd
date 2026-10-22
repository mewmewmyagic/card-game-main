extends Resource
class_name StatusEffectInstance

signal count_changed
signal stack_changed

@export var status_effect_resource: StatusEffect

var target: Combatant
var manager: StatusEffectManager
var stack: int = 0
var count: int = 0

func init(c: Combatant, s: StatusEffectManager) -> void:
	pass

func proc_status_effect() -> void:
	pass
	
func on_effect_applied() -> void:
	pass

func on_effect_removed() -> void:
	pass
	
func add_count(n: int) -> void:
	count = clamp(count + n, 0, status_effect_resource.max_count)
	count_changed.emit()
	
func add_stack(n: int) -> void:
	stack = clamp(stack + n, 0, status_effect_resource.max_stack)
	stack_changed.emit()
