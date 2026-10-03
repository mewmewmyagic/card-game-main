extends Resource
class_name StatusEffect

@export_group("Stuff")
@export var id: String = ""
@export_multiline var tooltip: String = ""
@export var max_stack: int = 1
@export var max_count: int = 1

var target: Combatant
var manager: StatusEffectManager

@export var stack: int = 0
@export var count: int = 0

func init(c: Combatant, s: StatusEffectManager) -> void:
	target = c
	manager = s

func trigger_status_effect(c: Combatant) -> void:
	pass
	
func add_count(n: int) -> void:
	count += n
	
func add_stack(n: int) -> void:
	stack += n
