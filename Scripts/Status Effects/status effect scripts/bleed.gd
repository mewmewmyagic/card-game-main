extends StatusEffect
class_name BleedStatusEffect

func init(_target: Combatant, _manager: StatusEffectManager) -> void:
	super.init(_target, _manager)
	target.anim_done.connect(_on_anim_done)

func on_remove() -> void:
	target.anim_done.disconnect(_on_anim_done)

func _on_anim_done() -> void:
	target.take_damage(stack)
	count -= 1
	print(count)
	if count <= 0:
		manager.remove_status(id)
