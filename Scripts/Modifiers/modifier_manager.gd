class_name ModifierManager
extends Node

var modifiers: Array[ModifierBase] = []

func add(m: ModifierBase) -> void:
	remove(m.id)   # same id replaces
	modifiers.append(m)

func remove(id: String) -> void:
	for i in range(modifiers.size()):
		if modifiers[i].id == id:
			modifiers.remove_at(i)

func apply(type: ModifierBase.Type, base: float, ctx = null) -> float:
	var flat := 0.0
	var percent := 0.0
	for m in modifiers:
		if m.type != type or not m.filter(ctx):
			continue
		if m.operation == ModifierBase.Operation.FLAT:
			flat += m.value
		else:
			percent += m.value
	var final_value = (base + flat) * (1.0 + percent)
	return final_value
