extends StatusEffect
class_name FocusStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	target = _target
	manager = _manager
	self.stack_changed.connect(queue_status_action)
	target.card_played.connect(_reduce_count)
	
func on_remove() -> void:
	var modifier := target.modifier_manager.get_modifier(Modifier.Type.dmg_dealt) as Modifier
	modifier.remove_value("focus")
	self.stack_changed.disconnect(queue_status_action)
	target.card_played.disconnect(_reduce_count)

func proc_status_effect() -> void:
	var modifier := target.modifier_manager.get_modifier(Modifier.Type.dmg_dealt) as Modifier
	var value := modifier.get_value("focus")
	if not value:
		value = ModifierValue.create_new_modifier("focus", ModifierValue.ModifierType.FLAT)

	value.flat_value = stack
	modifier.add_new_value(value)

func _reduce_count(card: Card) -> void:
	if (card.target_type == card.TargetType.ENEMY or card.target_type == card.TargetType.ALL_ENEMY):
		add_count(-1)
	if count <= 0:
		manager.remove_status(id)
