class_name ModifierBase
extends RefCounted

enum Operation { FLAT, PERCENT }
enum Type { dmg_dealt, dmg_taken, recov_cost, card_cost }

var id: String
var type: Type
var operation: Operation
var value: float

func _init(p_id: String, p_type: Type, p_op: Operation, p_value: float) -> void:
	id = p_id
	type = p_type
	operation = p_op
	value = p_value

# Subclasses override this to filter. ctx is whatever the caller passes in.
func filter(_ctx) -> bool:
	return true
