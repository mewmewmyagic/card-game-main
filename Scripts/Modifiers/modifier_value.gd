extends Node
class_name ModifierValue

enum Type {FLAT, PERCENT}

@export var type: Type
@export var percent_value: float
@export var flat_value: int
@export var source: String

static func create_new_modifier(source: String, type: Type) -> ModifierValue:
	var new_modifer := new()
	new_modifer.source = source
	new_modifer.type = type
	
	return new_modifer
