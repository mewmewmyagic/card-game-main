class_name Modifier
extends RefCounted

enum Type {dmg_dealt, dmg_taken, recov_cost, card_cost}
var type: Type

var _values: Array[ModifierValue] = []

func _init(p_type: Type = Type.dmg_dealt) -> void:
	type = p_type

func get_value(id: String) -> ModifierValue:
	for value in _values:
		if value.id == id:
			return value
	return null

func add_new_value(value: ModifierValue) -> void:
	var modifier_value := get_value(value.id)
	if modifier_value == null:
		_values.append(value)
	else:
		modifier_value.type = value.type
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value

func remove_value(id: String) -> void:
	_values = _values.filter(func(value: ModifierValue) -> bool: return value.id != id)

func remove_all_value() -> void:
	_values.clear()

func apply_modifiers(damage: DamagePacket) -> int:
	var flat_result: int = damage.amount
	var percentage: float = 1.0

	for value in _values:
		if not value.applies_to(damage.damage_type):
			continue
		match value.type:
			ModifierValue.ModifierType.FLAT:
				flat_result += value.flat_value
			ModifierValue.ModifierType.PERCENT:
				percentage += value.percent_value
	
	print("percent %.2f ", percentage)
	return floori(flat_result * percentage)
