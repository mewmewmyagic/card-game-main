class_name DamageResolver
extends RefCounted

var battle: BattleState

func resolve(damage: DamagePacket) -> int:
	if damage.source != null:
		damage.amount = damage.source.modifier_manager.get_modified_value(damage, Modifier.Type.dmg_dealt)
		
	if damage.target != null:
		damage.amount = damage.target.modifier_manager.get_modified_value(damage, Modifier.Type.dmg_taken)
		damage.target.take_damage(damage.amount)
	

	print(damage.source, damage.amount)
	return damage.amount
