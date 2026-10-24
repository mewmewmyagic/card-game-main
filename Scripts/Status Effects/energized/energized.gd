extends StatusEffect
class_name EnergizedStatusEffect

func init(_target: Combatant, _manager: StatusEffectHandler) -> void:
	target = _target
	manager = _manager
	EventBus.round_started.connect(queue_status_action)

func on_effect_removed() -> void:
	EventBus.round_started.disconnect(queue_status_action)

func proc_status_effect() -> void:
	target.stats.stamina += stack
	add_count(-1)
	manager.remove_status(id)
