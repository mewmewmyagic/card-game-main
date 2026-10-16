extends StatusEffect
class_name EnergizedStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	target = _target
	manager = _manager
	target.battle_state.turn_manager.round_started.connect(trigger_status_effect)

func on_remove() -> void:
	target.battle_state.turn_manager.round_started.disconnect(trigger_status_effect)

func trigger_status_effect() -> void:
	target.stats.stamina += stack
	add_count(-1)
	manager.remove_status(id)
