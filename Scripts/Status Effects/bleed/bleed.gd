extends StatusEffect
class_name BleedStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	target = _target
	manager = _manager
	target.anim_done.connect(trigger_status_effect)

func on_remove() -> void:
	target.anim_done.disconnect(trigger_status_effect)

func trigger_status_effect() -> void:
	var damage := DamagePacket.create(stack, null, target, DamageType.Type.BLEED)
	target.battle_state.damage_resolver.resolve(damage)
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
