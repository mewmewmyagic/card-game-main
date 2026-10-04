class_name ModifierValue
extends RefCounted

enum Type {FLAT, PERCENT}

var type: Type
var percent_value: float
var flat_value: int
var source: String

static func create_new_modifier(source: String, type: Type) -> ModifierValue:
	var new_modifier := ModifierValue.new()
	new_modifier.source = source
	new_modifier.type = type

	return new_modifier
