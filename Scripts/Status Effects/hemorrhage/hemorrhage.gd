extends StatusEffect
class_name HemorrhageStatusEffect
	
func on_effect_applied() -> void:
	self.stack_changed.connect(update_modifier)
	
func on_effect_removed() -> void:
	self.stack_changed.disconnect(update_modifier)
	self.remove_requested.emit()

func update_modifier() -> void:
	parent.modifier_manager.add(DamageModifier.new(self.id, ModifierBase.Type.dmg_taken, ModifierBase.Operation.PERCENT, stack/10.0, DamageType.Type.BLEED))

func proc_status_effect() -> void:
	add_count(-1)
