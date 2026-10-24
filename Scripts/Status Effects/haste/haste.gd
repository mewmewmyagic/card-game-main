extends StatusEffect
class_name HasteStatusEffect

func init(_target: Combatant, _manager: StatusEffectHandler) -> void:
	target = _target
	manager = _manager
	EventBus.turn_ended.connect(proc_status_effect)

func on_remove() -> void:
	EventBus.turn_ended.disconnect(proc_status_effect)

func proc_status_effect() -> void:
	target.stats.set_recovery_time(-stack)
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
