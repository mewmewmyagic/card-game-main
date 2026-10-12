extends RefCounted
class_name DamagePacket

var damage_type: DamageType.Type
var amount: int
var source: Combatant
var target: Combatant

static func create(p_amount: int, p_source: Combatant, p_target: Combatant, p_damage_type: DamageType.Type) -> DamagePacket:
	var info := DamagePacket.new()
	
	info.amount = p_amount
	info.damage_type = p_damage_type
	
	info.source = p_source
	info.target = p_target

	return info
