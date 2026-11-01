extends Resource
class_name StatusEffect

signal count_changed
signal stack_changed

signal instance_removed
signal remove_requested

@export_group("Stuff")
@export var id: String = "No name"
@export var icon: Texture2D = preload("res://Textures/Debug/error.webp")
@export_multiline var description: String = "No description"
@export var max_stack: int = 1
@export var max_count: int = 1

var parent: Combatant
var manager: StatusEffectHandler
var stack: int = 0
var count: int = 0

func init(_c: Combatant) -> void:
	parent = _c
	on_effect_applied()
	
func on_effect_applied() -> void: #first instantiated
	pass

func on_effect_removed() -> void: #removed
	pass
	
func queue_status_action() -> void: #dumb
	ActionQueue.push_back(StatusProcAction.create(self))

func proc_status_effect() -> void:
	pass
	
func add_count(n: int) -> void:
	count = clamp(count + n, 0, max_count)
	count_changed.emit()
	if count <= 0:
		self.remove_requested.emit()
	
func add_stack(n: int) -> void:
	stack = clamp(stack + n, 0, max_stack)
	stack_changed.emit()
