extends Node
class_name Modifier

enum Type {dmg_dealt, dmg_taken, recov_cost, card_cost}
@export var type: Type

func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source == source:
			return value
	return null
	
func add_new_value(value: ModifierValue) -> void:
	print(value.source)
	var modifier_value := get_value(value.source)
	if not (modifier_value == null):
		add_child(modifier_value)
	else:
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value
		
func remove_value(source: String) -> void:
	for value: ModifierValue in get_children():
		if value.source == source:
			value.queue_free()

func remove_all_value(source: String) -> void:
	for value: ModifierValue in get_children():
		value.queue_free()

func get_modified_value(base: int) -> int:
	var flat_result: int = base
	var percentage: float = 1.0
	
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.FLAT:
			flat_result += value.flat_value
			
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.PERCENT:
			percentage += value.percent_value
	
	return floori(flat_result * percentage)
