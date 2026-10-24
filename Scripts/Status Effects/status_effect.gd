extends Resource
class_name StatusEffect

signal count_changed
signal stack_changed
signal removed

@export_group("Stuff")
@export var id: String = ""
@export var icon: Texture2D
@export_multiline var tooltip: String = ""
@export var max_stack: int = 1
@export var max_count: int = 1

var target: Combatant
var manager: StatusEffectHandler
var stack: int = 0
var count: int = 0

func init(_c: Combatant, _s: StatusEffectHandler) -> void:
	pass

func queue_status_action() -> void:
	ActionQueue.push_back(StatusProcAction.create(self))

func proc_status_effect() -> void:
	pass
	
func on_effect_applied() -> void:
	pass

func on_effect_removed() -> void:
	pass
	
func add_count(n: int) -> void:
	count = clamp(count + n, 0, max_count)
	count_changed.emit()
	
func add_stack(n: int) -> void:
	stack = clamp(stack + n, 0, max_stack)
	stack_changed.emit()
