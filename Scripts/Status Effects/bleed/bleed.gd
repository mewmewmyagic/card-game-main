extends StatusEffect
class_name BleedStatusEffect

func init(_target: Combatant, _manager: StatusEffectHandler) -> void:
	target = _target
	manager = _manager
	target.anim_done.connect(queue_status_action)

func on_effect_removed() -> void:
	target.anim_done.disconnect(queue_status_action)

func proc_status_effect() -> void:
	var damage := DamagePacket.create(stack, null, target, DamageType.Type.BLEED)
	DamageHandler.deal_damage(damage)
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
