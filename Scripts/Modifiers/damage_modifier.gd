class_name DamageModifier
extends ModifierBase

var damage_type: int = -1   # -1 = any damage type

func _init(p_id: String, p_type: Type, p_op: Operation, p_value: float, p_damage_type: int = -1) -> void:
	super(p_id, p_type, p_op, p_value)
	damage_type = p_damage_type

func applies_to(packet) -> bool:
	return damage_type == -1 or packet.damage_type == damage_type
