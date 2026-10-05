extends Node
class_name ModifierManager

var _modifiers: Dictionary = {}

func _init() -> void:
	for type in Modifier.Type.values():
		_modifiers[type] = Modifier.new(type)

func get_modifier(type: Modifier.Type) -> Modifier:
	return _modifiers.get(type)


func get_modified_value(base: int, type: Modifier.Type) -> int:
	var modifier := get_modifier(type)

	if not modifier:
		return base

	return modifier.get_modified_value(base)
