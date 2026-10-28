extends StatusEffect
class_name BleedStatusEffect

func init(_target: Combatant, _manager: StatusEffectHandler) -> void:
	target = _target
	manager = _manager
	target.card_played.connect(_decide)

func on_effect_removed() -> void:
	target.card_played.disconnect(_decide)

func _decide(c: Card) -> void:
	if (c.card_type == Card.CardType.ATTACK):
		queue_status_action()

func proc_status_effect() -> void:
	var damage := DamagePacket.create(stack, null, target, DamageType.Type.BLEED)
	DamageHandler.deal_damage(damage)
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
