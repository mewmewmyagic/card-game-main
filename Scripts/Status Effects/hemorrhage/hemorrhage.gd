extends StatusEffect
class_name HemorrhageStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	target = _target
	manager = _manager
	self.stack_changed.connect(trigger_status_effect)
	target.battle_state.turn_manager.turn_ended.connect(_reduce_count)
	
func on_remove() -> void:
	var modifier := target.modifier_manager.get_modifier(Modifier.Type.dmg_taken) as Modifier
	modifier.remove_value(self.id)
	self.stack_changed.disconnect(trigger_status_effect)
	target.battle_state.turn_manager.turn_ended.disconnect(_reduce_count)

func trigger_status_effect() -> void:
	var modifier := target.modifier_manager.get_modifier(Modifier.Type.dmg_taken) as Modifier
	var value := modifier.get_value(self.id)
	if not value:
		value = ModifierValue.create_new_modifier(self.id, ModifierValue.ModifierType.PERCENT, DamageType.Type.BLEED)
	
	value.percent_value = stack / 10.0 # times 10 per stack divided by 100 to convert to percentage
	modifier.add_new_value(value)

func _reduce_count(_c: Combatant) -> void:
	add_count(-1)
	if count <= 0:
		manager.remove_status(id)
