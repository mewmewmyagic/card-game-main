extends StatusEffect
class_name BleedStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	target = _target
	manager = _manager
	target.anim_done.connect(queue_status_action)

func on_remove() -> void:
	target.anim_done.disconnect(queue_status_action)

func proc_status_effect() -> void:
	var damage := DamagePacket.create(stack, null, target, DamageType.Type.BLEED)
	target.battle_state.damage_resolver.resolve(damage)
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
