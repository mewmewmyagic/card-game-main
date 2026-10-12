class_name ModifierValue
extends RefCounted

enum ModifierType { FLAT, PERCENT }

var type: ModifierType
var percent_value: float
var flat_value: int
var id: String
var effected_type: DamageType.Type

static func create_new_modifier(modifier_id: String, modifier_type: ModifierType, modifier_effected_type: DamageType.Type = -1) -> ModifierValue:
	var new_modifier := ModifierValue.new()
	new_modifier.id = modifier_id
	new_modifier.type = modifier_type
	new_modifier.effected_type = modifier_effected_type

	return new_modifier

func applies_to(t: DamageType.Type) -> bool:
	return effected_type == -1 or t == effected_type
