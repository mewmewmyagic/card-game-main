extends Control
class_name StatusEffectIcon

@export var status: StatusEffect : set = set_status

@onready var icon: TextureRect = $"status icon"
@onready var stack: Label = $stack
@onready var count: Label = $count

func set_status(new_status: StatusEffect) -> void:
	if not is_node_ready():
		await ready
		
	status = new_status
	icon.texture = status.icon
	custom_minimum_size = icon.size * 2
	
	if not status.stack_changed.is_connected(_on_status_changed):
		status.stack_changed.connect(_on_status_changed)
	
	if not status.count_changed.is_connected(_on_status_changed):
		status.count_changed.connect(_on_status_changed)
		
	_on_status_changed()
	
func _on_status_changed() -> void:
	if not status:
		return
	
	if status.count == 0:
		queue_free()
		
	stack.text = str(status.stack)
	if status.stack == 0:
		stack.hide()
	count.text = str(status.count)
