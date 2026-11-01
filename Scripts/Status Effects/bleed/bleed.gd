extends StatusEffect
class_name BleedStatusEffect

func on_effect_applied() -> void:
	parent.card_played.connect(_decide)
	
func on_effect_removed() -> void:
	parent.card_played.disconnect(_decide)

func _decide(c: Card) -> void:
	if (c.card_type == Card.CardType.ATTACK):
		self.queue_status_action()

func proc_status_effect() -> void:
	var damage := DamagePacket.create(stack, null, parent, DamageType.Type.BLEED)
	DamageHandler.deal_damage(damage)
	add_count(-1)
