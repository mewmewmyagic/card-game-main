# damage_handler.gd
class_name DamageHandler
extends RefCounted

class Result:
	var amount: int
	var to_shield: int
	var to_health: int
	var kills: bool

static func calculate(p_packet: DamagePacket) -> Result:
	# work on a copy so the caller's packet is never mutated
	var packet := DamagePacket.create(p_packet.amount, p_packet.source, p_packet.target, p_packet.damage_type)

	if packet.source:
		packet.amount = packet.source.modifier_manager.get_modified_value(packet, Modifier.Type.dmg_dealt)
	if packet.target:
		packet.amount = packet.target.modifier_manager.get_modified_value(packet, Modifier.Type.dmg_taken)

	var r := Result.new()
	r.amount = packet.amount
	if packet.target:
		r.to_shield = mini(packet.amount, packet.target.stats.shield)
		r.to_health = packet.amount - r.to_shield
		r.kills = r.to_health >= packet.target.stats.health
	return r

static func deal_damage(packet: DamagePacket) -> Result:
	var r := calculate(packet)
	if packet.target:
		packet.target.apply_damage(r.to_shield, r.to_health)
	return r
