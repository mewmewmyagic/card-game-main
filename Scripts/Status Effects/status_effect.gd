extends Resource
class_name StatusEffect

@export_group("Stuff")
@export var id: String = ""
@export_multiline var tooltip: String = ""
@export var max_stack: int = 1
@export var max_count: int = 1

var target: Combatant
var manager: StatusEffectManager
var stack: int = 0
var count: int = 0

func init(c: Combatant, s: StatusEffectManager) -> void:
	pass

func trigger_status_effect() -> void:
	pass
	
func on_effect_applied() -> void:
	pass

func on_effect_removed() -> void:
	pass
	
func add_count(n: int) -> void:
	count = clamp(count + n, 0, max_count)
	
func add_stack(n: int) -> void:
	stack = clamp(stack + n, 0, max_stack)
