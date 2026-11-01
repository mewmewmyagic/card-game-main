extends StatusEffect
class_name EnergizedStatusEffect

func on_effect_applied() -> void:
	EventBus.round_started.connect(queue_status_action)
	
func on_effect_removed() -> void:
	EventBus.round_started.disconnect(queue_status_action)

func proc_status_effect() -> void:
	parent.stats.stamina += stack
	add_count(-1)
